//
//  DiceInteractor.swift
//  Opus
//
//  Created by David Hansson on 08/08/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol DiceBusinessLogic {
    func doSomething(request: Dice.Something.Request)
}

protocol DiceDataStore {
    //var name: String { get set }
}

class DiceInteractor: DiceBusinessLogic, DiceDataStore {
    var presenter: DicePresentationLogic?
    var worker: DiceWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Dice.Something.Request) {
        worker = DiceWorker()
        worker?.doSomeWork()
        
        let response = Dice.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
