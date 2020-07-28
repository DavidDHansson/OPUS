//
//  HomeRouter.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

@objc protocol HomeRoutingLogic {
    func navigateToWelcome()
    func navigateToSettings()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Navigation

    func navigateToWelcome() {
        let vc = WelcomeViewController()
        
        let destination = UINavigationController(rootViewController: vc)
        destination.modalPresentationStyle = .overFullScreen
        
        viewController?.present(destination, animated: true)
    }
    
    func navigateToSettings() {
        let vc = SettingsViewController()
        self.viewController?.present(vc, animated: true)
    }
    
}
