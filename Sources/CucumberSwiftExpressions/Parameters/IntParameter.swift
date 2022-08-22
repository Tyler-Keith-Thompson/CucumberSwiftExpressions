//
//  IntParameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public struct IntParameter: Parameter {
    enum ParameterError: Error {
        case notANumber
    }

    public static let name = "int"

    public let regexMatch = #"-?\d+"#

    public func convert(input: String) throws -> Int {
        guard let int = Int(input) else {
            throw ParameterError.notANumber
        }

        return int
    }
}

extension Match {
    public var int: IntParameter {
        IntParameter()
    }
}
