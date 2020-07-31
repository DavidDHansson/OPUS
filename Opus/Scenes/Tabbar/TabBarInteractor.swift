//
//  TabBarInteractor.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol TabBarBusinessLogic {
    func doSomething(request: TabBar.Something.Request)
}

protocol TabBarDataStore {
    //var name: String { get set }
}

class TabBarInteractor: TabBarBusinessLogic, TabBarDataStore {
    var presenter: TabBarPresentationLogic?
    var worker: TabBarWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: TabBar.Something.Request) {
        worker = TabBarWorker()
        worker?.doSomeWork()
        
        let response = TabBar.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
