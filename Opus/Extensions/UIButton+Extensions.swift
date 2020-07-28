//
//  UIButton+Extensions.swift
//  Opus
//
//  Created by David Hansson on 26/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

extension UIButton {
    func applyGradient(colors: [CGColor], cornerRadius: CGFloat) {
        self.backgroundColor = nil

        let l = CAGradientLayer()
        l.name = "gradient_background"
        l.colors = colors
        l.startPoint = CGPoint(x: 0, y: 0)
        l.endPoint = CGPoint(x: 0, y: 1)
        l.frame = self.bounds
        l.cornerRadius = cornerRadius
        l.masksToBounds = false
        
        self.layer.cornerRadius = cornerRadius
        
        if self.layer.sublayers?.contains(where: { $0.name == "gradient_background"} ) ?? false {
            self.layer.sublayers?.remove(at: 0)
            self.layer.insertSublayer(l, at: 0)
        } else {
            self.layer.insertSublayer(l, at: 0)
        }
    }
}

