//
//  Parameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

import Foundation

public protocol Parameter {
    associatedtype Output

    static var name: String { get }

    var regexMatch: String { get }

    func convert(input: String) throws -> Output
}

extension Parameter {
    public func eraseToAnyParameter() -> AnyParameter {
        AnyParameter(self)
    }
}
