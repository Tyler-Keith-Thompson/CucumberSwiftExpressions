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
        var startIndex = str.startIndex
        for token in tokens {
            switch token {
                case .whitespace(_, let val):
                    guard let endIndex = str.index(startIndex, offsetBy: val.count, limitedBy: str.endIndex) else {
                        return nil
                    }

                    let substr = String(str[startIndex..<endIndex])

                    guard substr == val else { return nil }

                    startIndex = endIndex
                case .parameter(_, let parameterName):
                    guard let lookup = Self.parameterLookup[parameterName] else {
                        return nil
                    }

                    let regex = "(\(lookup.regexMatch))"
                    let substr = String(str[startIndex...])
                    let matches = matches(in: substr, regex: regex)

                    guard !matches.isEmpty else { return nil }

                    match.append(token, matchedText: lookup.selectMatch(matches))
                    startIndex = str.index(startIndex, offsetBy: matches[0].count, limitedBy: str.endIndex) ?? str.endIndex
                case .alternate(_, let alternates):
                    let regex = "(?:\(alternates.lazy.map(NSRegularExpression.escapedPattern(for:)).joined(separator: "|")))"
                    let substr = String(str[startIndex...])
                    let matches = matches(in: substr, regex: regex)

                    guard !matches.isEmpty else { return nil }

                    startIndex = str.index(startIndex, offsetBy: matches[0].count, limitedBy: str.endIndex) ?? str.endIndex
                case .optional(_, let optionalText):
                    let escapedText = NSRegularExpression.escapedPattern(for: optionalText)
                    let regex = "(?:\(escapedText))?"
                    let substr = String(str[startIndex...])
                    let matches = matches(in: substr, regex: regex)

                    guard !matches.isEmpty else { return nil }

                    startIndex = str.index(startIndex, offsetBy: matches[0].count, limitedBy: str.endIndex) ?? str.endIndex
                case .literal(_, let val):
                    let regex = NSRegularExpression.escapedPattern(for: val)
                    let substr = String(str[startIndex...])
                    let matches = matches(in: substr, regex: regex)

                    guard !matches.isEmpty else { return nil }

                    startIndex = str.index(startIndex, offsetBy: matches[0].count, limitedBy: str.endIndex) ?? str.endIndex
            }
        }
        return match
    }

    private func matches(in str: String, regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: str,
                                        range: NSRange(str.startIndex..., in: str))
            guard let firstResult = results.first else { return [] }
            var matches = [String]()
            for i in 0..<firstResult.numberOfRanges {
                if let range = Range(firstResult.range(at: i), in: str) {
                    matches.append(String(str[range]))
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
