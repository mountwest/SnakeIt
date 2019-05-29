//
//  Configuration.swift
//  Snake It AR
//
//  Created by Jonathan Hallén on 2019-05-28.
//  Copyright © 2019 snake-group. All rights reserved.
//

import CoreGraphics

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let edge: UInt32 = 0x1
    static let snake: UInt32 = 0x1 << 1
    static let tree: UInt32 = 0x1 << 2
    static let food: UInt32 = 0x1 << 3
}
