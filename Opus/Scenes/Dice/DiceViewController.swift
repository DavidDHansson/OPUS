//
//  DiceViewController.swift
//  Opus
//
//  Created by David Hansson on 08/08/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit

protocol DiceDisplayLogic: class {
    func displaySomething(viewModel: Dice.Something.ViewModel)
}

class DiceViewController: UIViewController, DiceDisplayLogic {
    var interactor: DiceBusinessLogic?
    var router: (NSObjectProtocol & DiceRoutingLogic & DiceDataPassing)?
    
    var angle = CGPoint.init(x: 0, y: 0)
    
    private let diceView: UIView = {
        let v = UIView(frame: .zero)
        return v
    }()
    
    
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
        let interactor = DiceInteractor()
        let presenter = DicePresenter()
        let router = DiceRouter()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 250)

        
        // Add dice and subviews
        addDice()
        
        // Define Layout
        defineLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewTransform))
        diceView.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func addDice() {
        
        let viewFrame = UIScreen.main.bounds
        var diceTransform = CATransform3DIdentity

        // 1
        let dice1 = UIImageView.init(image: UIImage(named: "dice1"))
        dice1.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice1.layer.transform = diceTransform
        
        // 6
        let dice6 = UIImageView.init(image: UIImage(named: "dice6"))
        dice6.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -50)
        dice6.layer.transform = diceTransform
        
        // 2
        let dice2 = UIImageView.init(image: UIImage(named: "dice2"))
        dice2.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (CGFloat.pi / 2), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice2.layer.transform = diceTransform
        
        // 5
        let dice5 = UIImageView.init(image: UIImage(named: "dice5"))
        dice5.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (-CGFloat.pi / 2), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice5.layer.transform = diceTransform
        
        // 3
        let dice3 = UIImageView.init(image: UIImage(named: "dice3"))
        dice3.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (-CGFloat.pi / 2), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice3.layer.transform = diceTransform
        
        // 4
        let dice4 = UIImageView.init(image: UIImage(named: "dice4"))
        dice4.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (CGFloat.pi / 2), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice4.layer.transform = diceTransform
        
        diceView.addSubview(dice1)
        diceView.addSubview(dice2)
        diceView.addSubview(dice3)
        diceView.addSubview(dice4)
        diceView.addSubview(dice5)
        diceView.addSubview(dice6)

        view.addSubview(diceView)
    }
    
    func defineLayout() {
        diceView.translatesAutoresizingMaskIntoConstraints = false
        diceView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        diceView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        diceView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        diceView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func viewTransform(sender: UIPanGestureRecognizer) {
        
        // Calculates the movement, based on the varible "angle"
        let point = sender.translation(in: diceView)
        let angleX = angle.x + (point.x / 60)
        let angleY = angle.y + (point.y / 60)
        
        // Moves the dice
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 0)
        diceView.layer.sublayerTransform = transform
        
        // Saves the angle
        if sender.state == .ended {
            angle.x = angleX
            angle.y = angleY
        }
    }
    
    func show(diceFace face: Int) {
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        
        var angleX = angle.x
        var angleY = angle.y
        
        switch face {
        case 1:
            print("-1-")
            angleX = 0
            angleY = 0
        case 2:
            print("-2-")
            angleX = (-CGFloat.pi / 2)
            angleY = 0
        case 3:
            print("-3-")
            angleX = 0
            angleY = (CGFloat.pi / 2)
        case 4:
            print("-4-")
            angleX = 0
            angleY = (-CGFloat.pi / 2)
        case 5:
            print("-5-")
            angleX = (CGFloat.pi / 2)
            angleY = (CGFloat.pi / 2)
        case 6:
            print("-6-")
            angleX = CGFloat.pi
            angleY = 0
        default: break
        }
        
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 0)
        diceView.layer.sublayerTransform = transform
        
        // Saves the angle
        angle.x = angleX
        angle.y = angleY
    }
    
    // MARK: Do something
    
    func displaySomething(viewModel: Dice.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}
