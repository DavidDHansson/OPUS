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
        let image: String?
        let type: PopupType
        
        enum PopupType {
            case information
            case aboutme
        }
    }
    
    private let blurView: UIVisualEffectView = {
        let v = UIVisualEffectView(frame: .zero)
        v.effect = UIBlurEffect(style: .extraLight)
        return v
    }()
    
    private let popupView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = .white
        v.layer.cornerRadius = 25
        return v
    }()
    
    private let imageView: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.contentMode = .scaleAspectFit
        i.clipsToBounds = true
        return i
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.font = Font.Roboto.bold.size(22)
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.textAlignment = .center
        l.font = Font.Roboto.regular.size(16)
        return l
    }()
    
    private let ignoreButton: UIImageView = {
        let i = UIImageView(image: UIImage(named: "closeButtonFilled"))
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    private let continueButton: UIButton = {
        let b = UIButton(frame: .zero)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = Font.Roboto.medium.size(16)
        return b
    }()
    
    init(viewModel: ViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        // TODO: set title, description and image here
        // Switch over the enum
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            let radius = self.continueButton.frame.size.height * 0.5
            self.continueButton.applyGradient(colors: [UIColor(r: 71, g: 151, b: 255).cgColor, UIColor(r: 0, g: 100, b: 227).cgColor], cornerRadius: radius)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        // Add Subview
        popupView.addSubview(ignoreButton)
        
        view.addSubview(blurView)
        view.addSubview(popupView)
        
        // Define Layout
        defineLayout()
    }
    
    func defineLayout() {
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
