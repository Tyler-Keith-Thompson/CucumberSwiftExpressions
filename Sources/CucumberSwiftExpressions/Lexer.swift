//
//  Lexer.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

import Foundation
final class Lexer: StringReader {
    override var position: Position {
        let pos = super.position
        return Position(line: pos.line, column: pos.column)
    }

    private func advance<T>(_ t: @autoclosure () -> T) -> T {
        advanceIndex()
        return t()
    }

    private func parseEscapeSequence(char: Character) -> Character? {
        if char.isEscapeCharacter,
           let next = nextChar {
            defer {
                advanceIndex()
                advanceIndex()
            }
            return next
        }
        return nil
    }

    private func readParameter() -> String {
        var str = ""
        while let char = currentChar {
            if let escapedCharacter = parseEscapeSequence(char: char) {
                str.append(escapedCharacter)
                continue
            }

            guard !char.isTrailingParameterBoundary else {
                break
            }

            str.append(char)
            advanceIndex()
        }
        return str
    }

    private func readOptional() -> String {
        var str = ""
        while let char = currentChar {
            if let escapedCharacter = parseEscapeSequence(char: char) {
                str.append(escapedCharacter)
                continue
            }

            guard !char.isTrailingOptionalBoundary else {
                break
            }

            str.append(char)
            advanceIndex()
        }
        return str
    }

    private func readAlternates() -> [String] {
        var alternates = [String]()
        var str = ""
        while let char = currentChar, !char.isWhitespace, !char.isLeadingParameterBoundary, !char.isLeadingOptionalBoundary {
            if let escapedCharacter = parseEscapeSequence(char: char) {
                str.append(escapedCharacter)
                continue
            }

            guard !char.isAlternateSeparator else {
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

    private func advanceToNextToken() -> Token? {
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
                    // swiftlint:disable:next force_unwrapping
                    return .literal(position, alternates.first!)
                }
        }
    }

    func lex() -> [Token] {
        var tokens = [Token]()
        while let token = advanceToNextToken() {
            tokens.append(token)
        }
        return tokens
    }
}
