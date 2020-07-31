//
//  TabBarPresenter.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol TabBarPresentationLogic {
    func presentSomething(response: TabBar.Something.Response)
}

class TabBarPresenter: TabBarPresentationLogic {
    weak var viewController: TabBarDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: TabBar.Something.Response) {
        let viewModel = TabBar.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
