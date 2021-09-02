//
//  customPageView.swift
//  SwiftyOnboard
//
//  Created by Jay on 3/25/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

open class SwiftyOnboardPage: UIView {
    
    private let stackView: UIStackView = {
        let s = UIStackView(frame: .zero)
        s.axis = .vertical
        s.alignment = .center
        s.distribution = .equalSpacing
        return s
    }()
    
    private let topView: UIView = {
        let v = UIView(frame: .zero)
        return v
    }()
    
    public var titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.font = Font.SanFranciscoDisplay.bold.size(35)
        l.textAlignment = .center
        l.numberOfLines = 3
        return l
    }()
    
    public var descriptionLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.font = Font.SanFranciscoDisplay.regular.size(20)
        l.textAlignment = .center
        l.numberOfLines = 5
        return l
    }()
    
    public var imageView: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        // Add subviews
        topView.addSubview(titleLabel)
        topView.addSubview(descriptionLabel)
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(imageView)
        addSubview(stackView)
        
        defineLayout()
        
    }
    
    func set(style: SwiftyOnboardStyle) {
        switch style {
        case .light:
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
        case .dark:
            titleLabel.textColor = .black
            descriptionLabel.textColor = .black
        }
    }
    
    func defineLayout() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4).isActive = true
        topView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        topView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.widthAnchor.constraint(equalTo: topView.widthAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6).isActive = true
        imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
    }

}
