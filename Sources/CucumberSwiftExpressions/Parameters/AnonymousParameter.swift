//
//  AnonymousParameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public struct AnonymousParameter: Parameter {
    public static let name = ""

    public let regexMatch = #".*"#

    public func convert(input: String) throws -> String { input }
}

extension Match {
    public var anonymous: AnonymousParameter {
        AnonymousParameter()
    }
}
