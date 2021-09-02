//
//  SettingsHeaderView.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

protocol SettingHeaderViewDelegate: AnyObject {
    func configure(config: SettingsHeaderView.ViewModel)
}

class SettingsHeaderView: UITableViewHeaderFooterView {
    
    struct ViewModel {
        let title: String
    }
    
    private let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.textAlignment = .left
        l.textColor = UIColor(r: 137, g: 137, b: 137)
        l.font = Font.SanFranciscoDisplay.regular.size(15)
        return l
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsHeaderView: SettingHeaderViewDelegate {
    func configure(config: SettingsHeaderView.ViewModel) {
        titleLabel.text = config.title
    }
}
