//
//  DicePresenter.swift
//  Opus
//
//  Created by David Hansson on 08/08/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol DicePresentationLogic {
    func presentSomething(response: Dice.Something.Response)
}

class DicePresenter: DicePresentationLogic {
    weak var viewController: DiceDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Dice.Something.Response) {
        let viewModel = Dice.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
