//
//  WelcomeInteractor.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol WelcomeBusinessLogic {
    func doSomething(request: Welcome.Something.Request)
}

protocol WelcomeDataStore {
    //var name: String { get set }
}

class WelcomeInteractor: WelcomeBusinessLogic, WelcomeDataStore {
    var presenter: WelcomePresentationLogic?
    var worker: WelcomeWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Welcome.Something.Request) {
        worker = WelcomeWorker()
        worker?.doSomeWork()
        
        let response = Welcome.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
