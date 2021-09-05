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

enum OpusTypes: String, Codable {
    case normal
    case quickDrop
    case slowPart
    case slowPartQuickDrop
}

struct OpusType: Codable {
    let title: String
    let description: String
    let type: OpusTypes
    let weight: Double
    var enabled: Bool
}

var opus = [OpusType]()

let standardOpus = [
    OpusType(title: "Normal", description: "Normal Opus, med tilfældig \"drop\" de sidste 60 sekunder.", type: .normal, weight: 1, enabled: true),
    OpusType(title: "Langsom", description: "Normal opbygning, efterfulgt af \"langsomt del\" også \"drop\". Dette kan ske maksimum 2 gange.", type: .slowPart, weight: 0.5, enabled: true),
    OpusType(title: "Langsom også hurtig", description: "Normal opbygning, efterfulgt af \"langsomt del\" også \"drop\", men uden opbygning. Dette kan ske maksimum 2 gange.", type: .slowPartQuickDrop, weight: 0.4, enabled: true),
    OpusType(title: "Hurtig", description: "Normal opbygning med uventet \"drop\" efter 20 - 40 sekunder ", type: .quickDrop, weight: 0.2, enabled: true)
]
