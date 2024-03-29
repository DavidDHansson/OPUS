//
//  SettingsCell.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
    func didSwitch(isOn value: Bool, indexPath: IndexPath)
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
        s.onTintColor = UIColor(r: 71, g: 151, b: 255)
        return s
    }()
    
    var data: Settings.SettingsItem? {
        didSet {
            guard let item = data else { return }
            
            titleLabel.text = item.title
            switchButton.isHidden = true
            
            switch item.type {
            case .onOffSwitch:
                guard let state = item.isSwitchOn else { return }
                titleLabel.textColor = .black
                switchButton.isHidden = false
                switchButton.isOn = state
            case .reset:
                titleLabel.textColor = .red
                switchButtonWidthConstraint.constant = 0.0
            default:
                titleLabel.textColor = .black
                switchButtonWidthConstraint.constant = 0.0
            }
        }
    }
    
    var index: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Disable dark mode for view
        overrideUserInterfaceStyle = .light
        
        backgroundColor = .white
        
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
    
    @objc private func didSwitch(isOn value: Bool, indexPath: IndexPath) {
        guard let indexUn = index else { return }
        delegate?.didSwitch(isOn: value, indexPath: indexUn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
