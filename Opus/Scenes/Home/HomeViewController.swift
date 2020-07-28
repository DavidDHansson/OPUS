//
//  HomeViewController.swift
//  Opus
//
//  Created by David Hansson on 25/07/2020.
//  Copyright (c) 2020 David Hansson. All rights reserved.
//

import UIKit
import AVFoundation

protocol HomeDisplayLogic: class {
    
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    let player = Player()
    
    var playerState: Home.PlayerState = .disabled
    var isPaused: Bool = true
    
    private let stackView: UIStackView = {
        let s = UIStackView(frame: .zero)
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.alignment = .center
        return s
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.text = "O P U S"
        l.font = Font.Roboto.bold.size(48)
        l.textAlignment = .center
        l.textColor = .black
        return l
    }()
    
    private let buttonStackView: UIStackView = {
        let s = UIStackView(frame: .zero)
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.alignment = .center
        return s
    }()
    
    private let startButton: UIButton = {
        let b = UIButton(frame: .zero)
        b.setTitle("Start", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = Font.Roboto.regular.size(22)
        return b
    }()

    private let settingsButton: UIButton = {
        let b = UIButton(frame: .zero)
        b.setTitle("Indstillinger", for: .normal)
        b.backgroundColor = .clear
        b.clipsToBounds = true
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.black.cgColor
        b.titleLabel?.font = Font.Roboto.regular.size(22)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    private let helpButton: UIButton = {
        let b = UIButton(frame: .zero)
        b.setTitle("Hjælp", for: .normal)
        b.backgroundColor = .clear
        b.clipsToBounds = true
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.black.cgColor
        b.titleLabel?.font = Font.Roboto.regular.size(22)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    private let playButton: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.contentMode = .scaleAspectFit
        i.image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
        i.tintColor = UIColor(r: 209, g: 209, b: 214)
        return i
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
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
        view.backgroundColor = .white
        
        // Add subviews
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(settingsButton)
        buttonStackView.addArrangedSubview(helpButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(buttonStackView)
        stackView.addArrangedSubview(playButton)
        view.addSubview(stackView)
        
        // Define layout
        defineLayout()
        
        // Background gradient
        setUpGradient()
        
        // For showing welcome page
        welcomePage()
        
        // Setup player and logic
        player.setup()
        
        // Add observer
        NotificationCenter.default.addObserver(self, selector: #selector(disablePlayButton), name: NSNotification.Name(rawValue: "disablePlayButton"), object: nil)
        
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        playButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tooglePlayer)))
        helpButton.addTarget(self, action: #selector(navigateToWelcomePage), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            let radius = self.startButton.frame.size.height * 0.5
            self.settingsButton.layer.cornerRadius = radius
            self.helpButton.layer.cornerRadius = radius
            self.startButton.applyGradient(colors: [UIColor(r: 28, g: 128, b: 255).cgColor, UIColor(r: 0, g: 100, b: 227).cgColor], cornerRadius: radius)
        }
        
    }
    
    func defineLayout() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.15).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.35).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8).isActive = true
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor, multiplier: 0.25).isActive = true
        startButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor, multiplier: 0.25).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        helpButton.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor, multiplier: 0.25).isActive = true
        helpButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.25).isActive = true
        
    }
    
    func setUpGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(r: 214, g: 231, b: 255).cgColor, UIColor(r: 255, g: 255, b: 255).cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func welcomePage() {
        // Determine if it's users first time on app
        let numberOfOpenedTimes = UserDefaults.standard.integer(forKey: "numberOfAppOpenings")
        UserDefaults.standard.set(numberOfOpenedTimes + 1, forKey: "numberOfAppOpenings")

        if numberOfOpenedTimes == 0 {
            DispatchQueue.main.async {
                self.router?.navigateToWelcome()
            }
        }
    }
    
    @objc func navigateToWelcomePage() {
        router?.navigateToWelcome()
    }
    
    @objc func settingsTapped() {
        router?.navigateToSettings()
    }
    
    // MARK: Player & Logic
    
    @objc func start() {
        
        configurePlayer(withState: .playing)
        isPaused = false
        
        player.generateQueue()
        player.start()
        player.unPause()
        
    }
    
    @objc func tooglePlayer() {
        
        isPaused = !isPaused
        
        if isPaused {
            configurePlayer(withState: .paused)
            player.pause()
        } else {
            configurePlayer(withState: .playing)
            player.unPause()
        }
    }
    
    @objc func disablePlayButton() {
        configurePlayer(withState: .disabled)
    }
    
    func configurePlayer(withState state: Home.PlayerState) {
        switch state {
        case .disabled:
            playButton.isUserInteractionEnabled = false
            playButton.tintColor = UIColor(r: 209, g: 209, b: 214)
            playButton.image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
        case .paused:
            playButton.isUserInteractionEnabled = true
            playButton.image = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
        case .playing:
            playButton.isUserInteractionEnabled = true
            playButton.image = UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}
