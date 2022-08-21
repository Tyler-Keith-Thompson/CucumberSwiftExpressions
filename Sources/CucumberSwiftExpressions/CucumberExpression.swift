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
        return tokens
            .lazy
            .map {
                switch $0 {
                    case .whitespace(_, let val):
                        return val
                    case .parameter(_, let parameterName):
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
            .reduce("^") { $0 + String($1) } + "$"
    }()

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(_ str: String) {
        tokens = Lexer(str).lex()
    }
}
