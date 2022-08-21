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
}

extension Parameters {
    public static let string = StringParameter()
}
