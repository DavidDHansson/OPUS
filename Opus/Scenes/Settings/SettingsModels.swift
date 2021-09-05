//
//  SettingsModels.swift
//  Opus
//
//  Created by David Hansson on 26/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

enum Settings {
    // MARK: Use cases
    
    enum Something {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    struct SettingsItem {
        let title: String
        let type: SettingsItemType
        let opusType: OpusTypes?
        var isSwitchOn: Bool?
    }

    enum SettingsItemType {
        case onOffSwitch
        case reset
        case aboutMe
        case help
        case share
        case review
    }
}
