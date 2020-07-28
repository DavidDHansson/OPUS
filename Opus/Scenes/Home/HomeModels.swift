//
//  HomeModels.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

enum Home {
    // MARK: Use cases
    
    enum Something {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum Music: String {
        case buildUp = "buildup"
        case buildUpFull = "buildUpP3"
        case drop = "drop"
        case build = "p3"
        case slow = "slow"
        case bambam = "bambam"
    }
    
    struct Part {
        let music: Music
        let stopAfter: Decimal
    }
    
    enum PlayerState {
        case paused
        case playing
        case disabled
    }
    
}
