//
//  SettingsCell.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

protocol SettingsCellDelegate: class {
    func didSwitch(isOn value: Bool, cell: SettingsItem)
}

class SettingsCell: UITableViewCell {
    
    weak var delegate: SettingsCellDelegate?
    
    private var switchButtonWidthConstraint: NSLayoutConstraint!
    
    private let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        return l
    }()
    
    private let switchButton: UISwitch = {
        let s = UISwitch(frame: .zero)
        s.isHidden = true
        return s
    }()
    
    var data: SettingsItem? {
        didSet {
            guard let item = data else { return }
            
            titleLabel.text = item.title
            switchButton.isHidden = true
            
            switch item.type {
            case .onOffSwitch:
                switchButton.isHidden = false
            case .reset:
                titleLabel.textColor = .red
                switchButtonWidthConstraint.constant = 0.0
            case .information:
                titleLabel.textColor = .black
                switchButtonWidthConstraint.constant = 0.0
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add subviews
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchButton)
        
        // Define Layout
        defineLayout()
        
        // Targets
        switchButton.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
    }
    
    func defineLayout() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -15).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButtonWidthConstraint = switchButton.widthAnchor.constraint(equalToConstant: 60)
        switchButtonWidthConstraint.isActive = true
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
    }
    
    @objc private func didSwitch(sender: UISwitch) {
        guard let cell = data else { return }
        delegate?.didSwitch(isOn: sender.isOn, cell: cell)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
