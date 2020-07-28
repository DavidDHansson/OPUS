//
//  SettingsPresenter.swift
//  Opus
//
//  Created by David Hansson on 26/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol SettingsPresentationLogic {
    func presentSomething(response: Settings.Something.Response)
}

class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Settings.Something.Response) {
        let viewModel = Settings.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
