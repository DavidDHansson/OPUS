//
//  DiceRouter.swift
//  Opus
//
//  Created by David Hansson on 08/08/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

@objc protocol DiceRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol DiceDataPassing {
    var dataStore: DiceDataStore? { get }
}

class DiceRouter: NSObject, DiceRoutingLogic, DiceDataPassing {
    weak var viewController: DiceViewController?
    var dataStore: DiceDataStore?
    
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
    
    //func navigateToSomewhere(source: DiceViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: DiceDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
