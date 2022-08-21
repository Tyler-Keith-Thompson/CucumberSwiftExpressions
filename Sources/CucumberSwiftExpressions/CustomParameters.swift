//
//  CustomParameters.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

public protocol CustomParameters {
    static var additionalParameters: [AnyParameter] { get }
}

extension CustomParameters {
    static var parameterLookup: [String: AnyParameter] {
        Self.additionalParameters.reduce(into: [:]) { $0[$1.name] = $1 }
    }
}
