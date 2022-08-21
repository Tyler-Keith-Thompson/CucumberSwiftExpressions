//
//  Lexer.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

import Foundation
public final class Lexer: StringReader {
    internal var url: URL?

    public init(_ str: String, uri: String) {
        url = URL(string: uri)
        super.init(str)
    }

    override public var position: Position {
        let pos = super.position
        return Position(line: pos.line, column: pos.column, uri: url)
    }

    @discardableResult private func advance<T>(_ t:@autoclosure () -> T) -> T {
        advanceIndex()
        return t()
    }

    @discardableResult internal func readParameter() -> String {
        var str = ""
        while let char = currentChar {
            if char.isEscapeCharacter,
               let next = nextChar {
                str.append(next)
                advanceIndex()
                advanceIndex()
                continue
            }
            if char.isTrailingParameterBoundary {
                break
            }
            str.append(char)
            advanceIndex()
        }
        return str
    }

    @discardableResult internal func readOptional() -> String {
        var str = ""
        while let char = currentChar {
            if char.isEscapeCharacter,
               let next = nextChar {
                str.append(next)
                advanceIndex()
                advanceIndex()
                continue
            }
            if char.isTrailingOptionalBoundary {
                break
            }
            str.append(char)
            advanceIndex()
        }
        return str
    }

    @discardableResult internal func readAlternates() -> [String] {
        var alternates = [String]()
        var str = ""
        while let char = currentChar, !char.isWhitespace, !char.isLeadingParameterBoundary, !char.isLeadingOptionalBoundary {
            if char.isEscapeCharacter,
               let next = nextChar {
                str.append(next)
                advanceIndex()
                advanceIndex()
                continue
            }
            if char.isAlternateSeparator {
                alternates.append(str)
                str = ""
                advanceIndex()
                continue
            }
            str.append(char)
            advanceIndex()
        }
        alternates.append(str)
        return alternates
    }

    internal func advanceToNextToken() -> Token? {
        guard let char = currentChar else { return nil }
        let position = position

        switch char {
            case .leadingParameterBoundary:
                let parameter = advance(readParameter())
                return advance(.parameter(position, parameter))
            case .leadingOptionalBoundary:
                let optional = advance(readOptional())
                return advance(.optional(position, optional))
            case _ where char.isWhitespace:
                let whitespace = readUntil { !$0.isWhitespace }
                return .whitespace(position, whitespace)
            default:
                let alternates = readAlternates()
                if alternates.count > 1 {
                    return .alternate(position, alternates)
                } else {
                    return .literal(position, alternates.first!)
                }
        }
    }

    public func lex() -> [Token] {
        var toks = [Token]()
        while let tok = advanceToNextToken() {
            toks.append(tok)
        }
        return toks
    }
}
