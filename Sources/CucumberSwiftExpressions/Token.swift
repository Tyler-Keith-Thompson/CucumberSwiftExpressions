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
        case whitespace(Lexer.Position, String)
        case parameter(Lexer.Position, String)
        case alternate(Lexer.Position, [String])
        case optional(Lexer.Position, String)
        case literal(Lexer.Position, String)

        public var position: Lexer.Position {
            switch self {
                case .whitespace(let pos, _): return pos
                case .parameter(let pos, _): return pos
                case .alternate(let pos, _): return pos
                case .optional(let pos, _): return pos
                case .literal(let pos, _): return pos
            }
        }

        #warning("FIXME")
        public static func == (lhs: Token, rhs: Token) -> Bool {
            switch (lhs, rhs) {
                case (.whitespace(_, let w1), .whitespace(_, let w2)):
                    return w1 == w2
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

        public var isLiteral: Bool {
            if case .literal = self {
                return true
            }
            return false
        }
    }
}
