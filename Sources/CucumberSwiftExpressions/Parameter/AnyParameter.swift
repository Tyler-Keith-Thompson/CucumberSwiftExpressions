//
//  AnyParameter.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//
//  swiftlint:disable file_types_order

import Foundation

public final class AnyParameter {
    fileprivate let storage: AnyParameterBase

    public var regexMatch: String {
        storage.regexMatch
    }

    public var name: String {
        storage.name
    }

    public init<P: Parameter>(_ parameter: P) {
        var param = parameter
        storage = AnyParameterStorage(&param)
    }

    public func selectMatch(_ matches: [String]) -> String {
        storage.selectMatch(matches)
    }
}

private class AnyParameterBase {
    var regexMatch: String {
        fatalError("regexMatch should've been overridden. This represents an internal library error.")
    }

    var name: String {
        fatalError("name should've been overridden. This represents an internal library error.")
    }

    func selectMatch(_ matches: [String]) -> String {
        fatalError("selectMatch(_:) should've been overridden. This represents an internal library error.")
    }
}

fileprivate final class AnyParameterStorage<P: Parameter>: AnyParameterBase {
    let hold: P
    init(_ parameter: inout P) {
        hold = parameter
    }

    override var regexMatch: String {
        hold.regexMatch
    }

    override var name: String {
        P.name
    }

    override func selectMatch(_ matches: [String]) -> String {
        hold.selectMatch(matches)
    }
}
