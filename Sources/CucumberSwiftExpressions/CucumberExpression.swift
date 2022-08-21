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

    public lazy var regex: String = {
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
                        return "(\(alternates.lazy.map(NSRegularExpression.escapedPattern(for:)).joined(separator: "|")))"
                    case .optional(_, let optionalText):
                        let escapedText = NSRegularExpression.escapedPattern(for: optionalText)
                        return "(\(escapedText))?"
                    case .literal(_, let val):
                        return NSRegularExpression.escapedPattern(for: val)
                }
            }
            .joined()
            .reduce("^") { $0 + String($1) } + "$"
    }()

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(_ str: String) {
        tokens = Lexer(str).lex()
    }
}

extension CucumberExpression {
    static let parameters: [AnyParameter] = {
        [
            Parameters.string.eraseToAnyParameter(),
            Parameters.int.eraseToAnyParameter(),
            Parameters.word.eraseToAnyParameter(),
            Parameters.float.eraseToAnyParameter(),
            Parameters.double.eraseToAnyParameter(),
            Parameters.anonymous.eraseToAnyParameter()
        ]
    }()

    static var parameterLookup: [String: AnyParameter] = {
        parameters
            .reduce(into: [:]) { $0[$1.name] = $1 }
            .merging((Self.self as? CustomParameters.Type)?.parameterLookup ?? [:]) { $1 }
    }()
}
