//
//  HomePresenter.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentSomething(response: Home.Something.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Home.Something.Response) {
        
    }
}
