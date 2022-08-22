//
//  FloatParameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public struct FloatParameter: Parameter {
    enum ParameterError: Error {
        case notANumber
    }

    public static let name = "float"

    public let regexMatch = #"(?=.*\d.*)[-+]?\d*(?:\.(?=\d.*))?\d*(?:\d+[E][+-]?\d+)?"#

    public func convert(input: String) throws -> Float {
        guard let float = Float(input) else {
            throw ParameterError.notANumber
        }

        return float
    }
}

extension Match {
    public var float: FloatParameter {
        FloatParameter()
    }
}
