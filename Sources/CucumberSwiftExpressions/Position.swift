//
//  Position.swift
//  CucumberSwiftExpressions
//
//  Created by Tyler Thompson on 8/20/22.
//  Copyright © 2022 Tyler Thompson. All rights reserved.
//

import Foundation

public struct Position: Hashable, Equatable {
    static let start: Position = {
        Position(line: 0, column: 0)
    }()
    public internal(set) var line: UInt
    public internal(set) var column: UInt
}
