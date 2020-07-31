//
//  AppDelegate.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbar: TabBarViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.tabbar = TabBarViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = self.tabbar
        window?.makeKeyAndVisible()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        return true
    }


}

