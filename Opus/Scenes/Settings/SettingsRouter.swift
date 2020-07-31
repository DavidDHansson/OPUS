//
//  SettingsRouter.swift
//  Opus
//
//  Created by David Hansson on 26/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

@objc protocol SettingsRoutingLogic {
    func navigateToHelp()
    func navigateToAboutMe()
}

protocol SettingsDataPassing {
    var dataStore: SettingsDataStore? { get }
}

class SettingsRouter: NSObject, SettingsRoutingLogic, SettingsDataPassing {
    weak var viewController: SettingsViewController?
    var dataStore: SettingsDataStore?
    
    // MARK: Navigation
    
    func navigateToHelp() {
        let vc = WelcomeViewController()
        
        let destination = UINavigationController(rootViewController: vc)
        destination.modalPresentationStyle = .overFullScreen
        
        viewController?.present(destination, animated: true)
    }
    
    func navigateToAboutMe() {
        
    }

}
