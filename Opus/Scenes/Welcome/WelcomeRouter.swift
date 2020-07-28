//
//  WelcomeRouter.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

@objc protocol WelcomeRoutingLogic {
    func popViewController()
}

protocol WelcomeDataPassing {
    var dataStore: WelcomeDataStore? { get }
}

class WelcomeRouter: NSObject, WelcomeRoutingLogic, WelcomeDataPassing {
    weak var viewController: WelcomeViewController?
    var dataStore: WelcomeDataStore?
    
    // MARK: Navigation
    
    func popViewController() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }

}
