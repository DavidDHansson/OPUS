//
//  WelcomePresenter.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol WelcomePresentationLogic {
    func presentSomething(response: Welcome.Something.Response)
}

class WelcomePresenter: WelcomePresentationLogic {
    weak var viewController: WelcomeDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Welcome.Something.Response) {
        let viewModel = Welcome.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
