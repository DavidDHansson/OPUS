//
//  SettingsItem.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

struct SettingsItem {
    let title: String
    let type: SettingsItemType
    let opusType: OpusTypes?
}

enum SettingsItemType {
    case onOffSwitch(isOn: Bool)
    case reset
    case aboutMe
    case help
}
