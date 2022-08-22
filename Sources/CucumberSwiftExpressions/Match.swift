//
//  Match.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/21/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public class Match {
    public enum MatchError: Error {
        case parameterNotFound
    }

    private var tokens = [Token]()

    func append(_ parameterToken: Lexer.Token, matchedText: String) {
        guard case .parameter(let position, let parameterName) = parameterToken else {
            return
        }

        tokens.append(Token(column: position.column, parameterName: parameterName, match: matchedText))
    }

    public subscript<P: Parameter>(keyPath: KeyPath<Match, P>, index index: Int) -> P.Output {
        let tokensForParameter = tokens
            .lazy
            .filter { $0.parameterName == P.name }
            .sorted { $0.column < $1.column }

        let token = tokensForParameter[index]

        let parameter = self[keyPath: keyPath]
        return try! parameter.convert(input: token.match)
    }

    public func first<P: Parameter>(_ keyPath: KeyPath<Match, P>) throws -> P.Output {
        try first(parameter: self[keyPath: keyPath])
    }

    public func first<P: Parameter>(parameter: P) throws -> P.Output {
        let tokensForParameter = tokens
            .lazy
            .filter { $0.parameterName == P.name }
            .sorted { $0.column < $1.column }

        guard let token = tokensForParameter.first else { throw MatchError.parameterNotFound }

        return try parameter.convert(input: token.match)
    }

    public func last<P: Parameter>(_ keyPath: KeyPath<Match, P>) throws -> P.Output {
        try last(parameter: self[keyPath: keyPath])
    }

    public func last<P: Parameter>(parameter: P) throws -> P.Output {
        let tokensForParameter = tokens
            .lazy
            .filter { $0.parameterName == P.name }
            .sorted { $0.column < $1.column }

        guard let token = tokensForParameter.last else { throw MatchError.parameterNotFound }

        return try parameter.convert(input: token.match)
    }

    public func allParameters<P: Parameter>(_ keyPath: KeyPath<Match, P>) throws -> [P.Output] {
        try allParameters(matching: self[keyPath: keyPath])
    }

    public func allParameters<P: Parameter>(matching parameter: P) throws -> [P.Output] {
        try tokens
            .lazy
            .filter { $0.parameterName == P.name }
            .sorted { $0.column < $1.column }
            .map { try parameter.convert(input: $0.match) }
    }
}

extension Match {
    private struct Token {
        let column: UInt
        let parameterName: String
        let match: String
    }
}
