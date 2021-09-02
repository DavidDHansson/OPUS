//
//  WelcomeViewController.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol WelcomeDisplayLogic: AnyObject {
    func displaySomething(viewModel: Welcome.Something.ViewModel)
}

class WelcomeViewController: UIViewController, WelcomeDisplayLogic {
    var interactor: WelcomeBusinessLogic?
    var router: (NSObjectProtocol & WelcomeRoutingLogic & WelcomeDataPassing)?
    
    var swiftyOnboard: SwiftyOnboard!
    let pages = [
        Welcome.OnBoardPage(title: "1. Del terninger ud", description: "Jo flere terninger - Jo sjovere \nDet anbefalet at have en terning for hver tredje person", image: "dice"),
        Welcome.OnBoardPage(title: "2. Klik på \"Start\" i appen", description: "(Husk at tage et besøg forbi indstillingerne)", image: nil),
        Welcome.OnBoardPage(title: "3. Slå med terningerne", description: "1 - Send terningen til højre \n2 - Send terningen til venstre \n6 - Send terningen til en valgfri", image: "multi"),
        Welcome.OnBoardPage(title: "4. BUND!", description: "Når musiken dropper, så bunder alle dem med en terning tilbage.", image: "users")
    ]
    
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
        let interactor = WelcomeInteractor()
        let presenter = WelcomePresenter()
        let router = WelcomeRouter()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        swiftyOnboard = SwiftyOnboard(frame: view.frame)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        
        setUpGradient()
    }

    func setUpGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(r: 173, g: 209, b: 255).cgColor, UIColor(r: 255, g: 255, b: 255).cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func popViewController() {
        router?.popViewController()
    }
    
    @objc func nextPage() {
        let page = swiftyOnboard.currentPage
        swiftyOnboard.goToPage(index: page + 1, animated: true)
    }
    
    func displaySomething(viewModel: Welcome.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension WelcomeViewController: SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return pages.count
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let page = SwiftyOnboardPage()
        let current = pages[index]
        
        page.titleLabel.text = current.title
        page.descriptionLabel.text = current.description
        
        if let img = current.image {
            page.imageView.image = UIImage(named: img)
        } else {
            page.imageView.image = nil
        }
        
        return page
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let view = SwiftyOnboardOverlay()
        
        view.skipButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        view.continueButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        view.continueButton.setTitle("Forsæt", for: .normal)
        
        return view
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {

        if position == Double(pages.count - 1) {
            overlay.continueButton.setTitle("Færdig", for: .normal)
            overlay.continueButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        } else {
            overlay.continueButton.setTitle("Forsæt", for: .normal)
            overlay.continueButton.removeTarget(nil, action: nil, for: .allEvents)
            overlay.continueButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        }
        
    }
    
}
