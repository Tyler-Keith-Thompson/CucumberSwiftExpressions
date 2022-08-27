//
//  StringParameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public struct StringParameter: Parameter {
    public static let name = "string"

    public let regexMatch = #""([^"\\]*(\\.[^"\\]*)*)"|'([^'\\]*(\\.[^'\\]*)*)'"#

    public func convert(input: String) throws -> String { input }

    public func selectMatch(_ matches: [String]) -> String {
        // The regex for this string will return 2 matches
        // The first includes quotes
        // The second removes those quotes
        matches[1]
    }
}

extension Match {
    public var string: StringParameter {
        StringParameter()
    }
}
