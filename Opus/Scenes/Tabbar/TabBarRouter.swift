//
//  TabBarRouter.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

@objc protocol TabBarRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol TabBarDataPassing {
    var dataStore: TabBarDataStore? { get }
}

class TabBarRouter: NSObject, TabBarRoutingLogic, TabBarDataPassing {
    weak var viewController: TabBarViewController?
    var dataStore: TabBarDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: TabBarViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: TabBarDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
