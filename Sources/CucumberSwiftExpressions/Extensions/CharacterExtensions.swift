//
//  CharacterExtensions.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/2022.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

import Foundation

extension Character {
    static let leadingParameterBoundary: Character = "{"
    static let trailingParameterBoundary: Character = "}"
    static let leadingOptionalBoundary: Character = "("
    static let trailingOptionalBoundary: Character = ")"
    static let alternateSeparator: Character = "/"
    static let escapeCharacter: Character = "\\"

    var value: Int32 {
        Int32(scalar.value)
    }
    var scalar: UnicodeScalar! {
        String(self).unicodeScalars.first
    }
    var isSpace: Bool {
        isspace(value) != 0
    }
    var isAlphanumeric: Bool {
        isalnum(value) != 0
    }
    var isNumeric: Bool {
        isnumber(value) != 0
    }
    var isSymbol: Bool {
        isLeadingParameterBoundary
        || isEscapeCharacter
    }
    var isLeadingParameterBoundary: Bool {
        self == Character.leadingParameterBoundary
    }
    var isTrailingParameterBoundary: Bool {
        self == Character.trailingParameterBoundary
    }
    var isLeadingOptionalBoundary: Bool {
        self == Character.leadingOptionalBoundary
    }
    var isTrailingOptionalBoundary: Bool {
        self == Character.trailingOptionalBoundary
    }
    var isAlternateSeparator: Bool {
        self == Character.alternateSeparator
    }
    var isEscapeCharacter: Bool {
        self == Character.escapeCharacter
    }
}
