//
//  SettingsFooterView.swift
//  Opus
//
//  Created by David Hansson on 03/08/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

protocol SettingsFooterViewDelegate: class {
    func configure(text: String)
}

class SettingsFooterView: UITableViewHeaderFooterView {
    
    private let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.textAlignment = .left
        l.textColor = UIColor(r: 137, g: 137, b: 137)
        l.font = UIFont.systemFont(ofSize: 15)
        l.numberOfLines = 7
        return l
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsFooterView: SettingsFooterViewDelegate {
    func configure(text: String) {
        titleLabel.text = text
    }
}
