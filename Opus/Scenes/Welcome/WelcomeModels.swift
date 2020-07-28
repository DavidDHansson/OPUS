//
//  WelcomeModels.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

enum Welcome {
    // MARK: Use cases
    
    enum Something {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    struct OnBoardPage {
        let title: String
        let description: String
        let image: String
    }
    
}
