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
    func routeToShareApp()
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
        let viewModel = PopupViewController.ViewModel(
            title: "Hej, jeg hedder David",
            description: "Jeg står bag denne formidable app, jeg håber du sætter pris på den. Tag et kig forbi min hjemmeside. Vi ses.",
            buttonText: "Besøg min side",
            image: "david",
            type: .aboutme
        )
        let destination = PopupViewController(viewModel: viewModel)
        destination.modalPresentationStyle = .overCurrentContext
        self.viewController?.tabBarController?.present(destination, animated: true, completion: nil)
    }
    
    func navigateToInformation(with opusClass: OpusType) {
        let viewModel = PopupViewController.ViewModel(title: opusClass.title, description: opusClass.description, buttonText: "Forstået", image: nil, type: .information)
        let destination = PopupViewController(viewModel: viewModel)
        destination.modalPresentationStyle = .overCurrentContext
        self.viewController?.tabBarController?.present(destination, animated: true, completion: nil)
    }
    
    func routeToShareApp() {
        let firstActivityItem = "Hey, tjek OPUS appen ud. Appen har millioner forskellige variationer af sangen, som gør at man aldrig hører den samme sang 2 gange! EN must-have til hygge druk og fester"
        let secondActivityItem: URL = URL(string: "https://apps.apple.com/us/app/opus/id1584135943#?platform=iphone")!

        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)

        // iPad stuff
        activityViewController.popoverPresentationController?.sourceView = viewController?.view
        activityViewController.popoverPresentationController?.permittedArrowDirections = .any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        viewController?.present(activityViewController, animated: true, completion: nil)
    }

}
