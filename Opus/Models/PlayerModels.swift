//
//  Music.swift
//  Opus
//
//  Created by David Hansson on 28/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

enum Bit: String {
    case buildUp = "buildup"
    case buildUpFull = "buildUpP3"
    case drop = "drop"
    case build = "p3"
    case slow = "slow"
    case bambam = "bambam"
}

struct Clip {
    let bit: Bit
    let stopAfter: Double
}

enum PlayerState {
    case paused
    case playing
    case disabled
}
