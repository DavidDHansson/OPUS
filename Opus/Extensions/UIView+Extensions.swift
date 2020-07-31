//
//  UIView+Extensions.swift
//  Opus
//
//  Created by David Hansson on 31/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.masksToBounds = false
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
