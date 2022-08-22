//
//  WordParameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public struct WordParameter: Parameter {
    public static let name = "word"

    public let regexMatch = #"[^\s]+"#

    public func convert(input: String) throws -> String { input }
}

extension Match {
    public var word: WordParameter {
        WordParameter()
    }
}
