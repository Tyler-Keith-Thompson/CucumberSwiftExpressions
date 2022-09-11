//
//  CucumberExpression.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

import Foundation

public struct CucumberExpression: ExpressibleByStringLiteral {
    private let tokens: [Lexer.Token]

    public var regex: String {
        tokens
            .lazy
            .map {
                switch $0 {
                    case .whitespace(_, let val): return val
                    case .parameter(_, let parameterName):
                        if let lookup = Self.parameterLookup[parameterName] {
                            return "(\(lookup.regexMatch))"
                        }
                        return ""
                    case .alternate(_, let alternates):
                        return "(?:\(alternates.lazy.map(NSRegularExpression.escapedPattern(for:)).joined(separator: "|")))"
                    case .optional(_, let optionalText):
                        let escapedText = NSRegularExpression.escapedPattern(for: optionalText)
                        return "(?:\(escapedText))?"
                    case .literal(_, let val):
                        return NSRegularExpression.escapedPattern(for: val)
                }
            }
            .joined()
            .reduce(into: "^") { $0 += String($1) } + "$"
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(_ str: String) {
        tokens = Lexer(str).lex()
    }

    public func match(in str: String) -> Match? {
        let match = Match()
        let parameters = tokens.filter { $0.isParameter }
        let regexMatches = matches(in: str, regex: regex)
        
        guard !regexMatches.isEmpty else { return nil }
        
        let matches = regexMatches
            .dropFirst() // first match is the whole string
                .reduce(into: [[(range: Range<String.Index>, match: String)]]()) { allMatches, tup in
                    let (range, strMatch) = tup
                    if let lastRange = allMatches.last?.first?.range,
                       lastRange.contains(range.lowerBound),
                       lastRange.contains(range.upperBound) {
                        allMatches[allMatches.count - 1].append((range, strMatch))
                    } else {
                        allMatches.append([(range, strMatch)])
                    }
                }

        guard matches.count == parameters.count else { return nil }

        for (offset, element) in parameters.enumerated() {
            guard case .parameter(_, let parameterName) = element,
                  let lookup = Self.parameterLookup[parameterName] else { return nil }
            let strMatches = matches[offset].map(\.match)
            match.append(element, matchedText: lookup.selectMatch(strMatches))
        }

        return match
    }

    private func matches(in str: String, regex: String) -> [(Range<String.Index>, String)] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: str,
                                        range: NSRange(str.startIndex..., in: str))
            guard let firstResult = results.first else { return [] }
            var matches = [(Range<String.Index>, String)]()
            for i in 0..<firstResult.numberOfRanges {
                if let range = Range(firstResult.range(at: i), in: str) {
                    matches.append((range, String(str[range])))
                }
            }
            return matches
        } catch {
            return []
        }
    }
}

extension CucumberExpression {
    static let parameters: [AnyParameter] = {
        [
            StringParameter().eraseToAnyParameter(),
            IntParameter().eraseToAnyParameter(),
            WordParameter().eraseToAnyParameter(),
            FloatParameter().eraseToAnyParameter(),
            DoubleParameter().eraseToAnyParameter(),
            AnonymousParameter().eraseToAnyParameter()
        ]
    }()

    static var parameterLookup: [String: AnyParameter] = {
        parameters
            .reduce(into: [:]) { $0[$1.name] = $1 }
            .merging((Self.self as? CustomParameters.Type)?.parameterLookup ?? [:]) { $1 }
    }()
}
