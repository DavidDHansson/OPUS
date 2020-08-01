//
//  SettingsRouter.swift
//  Opus
//
//  Created by David Hansson on 26/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol SettingsRoutingLogic {
    func navigateToHelp()
    func navigateToAboutMe()
    func navigateToInformation(with opus: OpusType)
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
    
    func navigateToInformation(with opusClass: OpusType) {
        let viewModel = PopupViewController.ViewModel(title: opusClass.title, description: opusClass.description, buttonText: "Forstået", image: nil, type: .information)
        let destination = PopupViewController(viewModel: viewModel)
        destination.modalPresentationStyle = .overCurrentContext
        self.viewController?.tabBarController?.present(destination, animated: true, completion: nil)
    }

}
