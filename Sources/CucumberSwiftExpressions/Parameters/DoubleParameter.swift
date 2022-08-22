//
//  DoubleParameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public struct DoubleParameter: Parameter {
    enum ParameterError: Error {
        case notANumber
    }

    public static let name = "double"

    public let regexMatch = #"(?=.*\d.*)[-+]?\d*(?:\.(?=\d.*))?\d*(?:\d+[E][+-]?\d+)?"#

    public func convert(input: String) throws -> Double {
        guard let double = Double(input) else {
            throw ParameterError.notANumber
        }

        return double
    }
}

extension Match {
    public var double: DoubleParameter {
        DoubleParameter()
    }
}
