//
//  PopupViewController.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    struct ViewModel {
        let title: String
        let description: String
        let buttonText: String
        let image: String?
        let type: PopupType
        
        enum PopupType {
            case information
            case aboutme
        }
    }
    
    private var showImage: Bool?
    
    private let blurView: UIVisualEffectView = {
        let v = UIVisualEffectView(frame: .zero)
        v.effect = UIBlurEffect(style: .extraLight)
        return v
    }()
    
    private let popupView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = .white
        v.layer.cornerRadius = 25
        v.backgroundColor = UIColor(r: 214, g: 232, b: 255)
        return v
    }()
    
    private let ignoreButton: UIImageView = {
        let i = UIImageView(image: UIImage(named: "closeButtonFilled"))
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    private let stackView: UIStackView = {
        let s = UIStackView(frame: .zero)
        s.axis = .vertical
        s.alignment = .center
        return s
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.font = Font.SanFranciscoDisplay.bold.size(22)
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
        
    private let imageView: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.textAlignment = .center
        l.font = Font.SanFranciscoDisplay.regular.size(16)
        l.numberOfLines = 0
        return l
    }()
    
    private let continueButton: UIButton = {
        let b = UIButton(frame: .zero)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = Font.SanFranciscoDisplay.medium.size(16)
        return b
    }()
    
    init(viewModel: ViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        continueButton.setTitle(viewModel.buttonText, for: .normal)
        
        switch viewModel.type {
        case .information:
            imageView.isHidden = true
            showImage = false
        case .aboutme:
            showImage = true
            imageView.isHidden = false
            guard let img = viewModel.image else { return }
            
            imageView.image = UIImage(named: img)?.withRoundedCorners(radius: 80)
        }   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            
            // Continuebutton
            let radius = self.continueButton.frame.size.height * 0.5
            self.continueButton.applyGradient(colors: [UIColor(r: 71, g: 151, b: 255).cgColor, UIColor(r: 0, g: 100, b: 227).cgColor], cornerRadius: radius)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        // Add Subview
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionLabel)
        popupView.addSubview(stackView)
        popupView.addSubview(continueButton)
        popupView.addSubview(ignoreButton)
        view.addSubview(blurView)
        view.addSubview(popupView)
        
        // Define Layout
        defineLayout()
        
        // Targets
        ignoreButton.isUserInteractionEnabled = true
        ignoreButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
        continueButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
    
    func defineLayout() {
        
        let img = showImage ?? true
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        ignoreButton.translatesAutoresizingMaskIntoConstraints = false
        ignoreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ignoreButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        ignoreButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15).isActive = true
        ignoreButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 15).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: img ? 0.8 : 0.5).isActive = true
        stackView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor, constant: -30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: img ? 0.2 : 0.2).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: img ? 0.5 : 0.0).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: img ? 0.3 : 0.8).isActive = true
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func continueAction() {
        if (showImage ?? true) {
            guard let url = URL(string: "https://4hansson.dk/#/") else { return }
            UIApplication.shared.open(url)
        } else {
            closeAction()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
