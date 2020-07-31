//
//  SettingsItem.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

// TODO: Hver settingsItem kan have en optional type, som passer med en model. Den model kunne være .slowQuickDrop, .normal, .quickDrop osv.
// Den enum/type kan sendes til settingsVC, og logikken kan laves der

struct SettingsItem {
    let title: String
    let type: SettingsItemType
}

enum SettingsItemType {
    case onOffSwitch(isOn: Bool)
    case reset
    case aboutMe
    case help
}
