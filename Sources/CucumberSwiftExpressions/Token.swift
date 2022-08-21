//
//  Token.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2018 Tyler Thompson. All rights reserved.
//

import Foundation

extension Lexer {
    public enum Token: Equatable, Hashable {
        case whitespace(Position, String)
        case parameter(Position, String)
        case alternate(Position, [String])
        case optional(Position, String)
        case literal(Position, String)

        public var position: Position {
            switch self {
                case .whitespace(let pos, _): return pos
                case .parameter(let pos, _): return pos
                case .alternate(let pos, _): return pos
                case .optional(let pos, _): return pos
                case .literal(let pos, _): return pos
            }
        }

        public static func == (lhs: Token, rhs: Token) -> Bool {
            switch (lhs, rhs) {
                case (.whitespace(_, let w1), .whitespace(_, let w2)):
                    return w1 == w2
                case (.parameter(_, let string1), .parameter(_, let string2)):
                    return string1 == string2
                case (.alternate(_, let stringArr1), .alternate(_, let stringArr2)):
                    return stringArr1 == stringArr2
                case (.optional(_, let string1), .optional(_, let string2)):
                    return string1 == string2
                case (.literal(_, let string1), .literal(_, let string2)):
                    return string1 == string2
                default:
                    return false
            }
        }

        public var valueDescription: String {
            switch self {
                case .whitespace(_, let val): return val
                case .parameter(_, let val): return val
                case .alternate(_, let val): return "\(val)"
                case .optional(_, let val): return val
                case .literal(_, let val): return val
            }
        }

        public var isWhitespace: Bool {
            if case .whitespace = self {
                return true
            }
            return false
        }

        public var isParameter: Bool {
            if case .parameter = self {
                return true
            }
            return false
        }

        public var isAlternate: Bool {
            if case .alternate = self {
                return true
            }
            return false
        }

        public var isOptional: Bool {
            if case .optional = self {
                return true
            }
            return false
        }

        public var isLiteral: Bool {
            if case .literal = self {
                return true
            }
            return false
        }
    }
}
