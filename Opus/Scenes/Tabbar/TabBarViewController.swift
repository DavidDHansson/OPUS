//
//  TabBarViewController.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol TabBarDisplayLogic: class {
    func displaySomething(viewModel: TabBar.Something.ViewModel)
}

class TabBarViewController: UITabBarController, TabBarDisplayLogic {
    var interactor: TabBarBusinessLogic?
    var router: (NSObjectProtocol & TabBarRoutingLogic & TabBarDataPassing)?
    
    private let homeVC = HomeViewController()
//    private let diceVC =
    private let settingsVC = SettingsViewController()
    
    private var layerGradient: CAGradientLayer?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = TabBarInteractor()
        let presenter = TabBarPresenter()
        let router = TabBarRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Style TabBar
        styleTabBar()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clean swift bug
        setup()
        
        // Setup TabBar
        setupTabBar()
        
    }
    
    private func styleTabBar() {

        if layerGradient == nil {
            layerGradient = CAGradientLayer()
            layerGradient?.colors = [UIColor(r: 92, g: 163, b: 255).cgColor, UIColor(r: 51, g: 139, b: 255).cgColor]
            layerGradient?.startPoint = CGPoint(x: 0.5, y: 0.0)
            layerGradient?.endPoint = CGPoint(x: 0.5, y: 1.0)
            layerGradient?.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: tabBar.bounds.height)
            self.tabBar.layer.insertSublayer(layerGradient!, at:0)
        }
        
        self.tabBar.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        self.tabBar.layer.masksToBounds = true
    }
    
    private func setupTabBar() {
        
        let homeNVC = UINavigationController(rootViewController: homeVC)
        homeNVC.tabBarItem = UITabBarItem(title: "Opus", image: UIImage(named: "iconsHomeIdle"), selectedImage: UIImage(named: "iconsHomeSelected"))
  
        let settingsNVC = UINavigationController(rootViewController: settingsVC)
        settingsNVC.tabBarItem = UITabBarItem(title: "Indstillinger", image: UIImage(named: "settingsIdle"), selectedImage: UIImage(named: "settingsSelected"))

        let controllers = [
            homeNVC,
            settingsNVC
        ]

        self.viewControllers = controllers
        
        self.selectedIndex = 1
        
        self.tabBar.barTintColor = UIColor(r: 214, g: 231, b: 255)
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    // MARK: Do something
    
    func displaySomething(viewModel: TabBar.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}
