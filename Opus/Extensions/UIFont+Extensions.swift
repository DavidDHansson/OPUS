//
//  UIFont+Extensions.swift
//  Opus
//
//  Created by David Hansson on 26/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

public enum Font { }

extension Font {
    public enum Roboto: String, FontConvertible {
        case medium = "Roboto-Medium"
        case regular = "Roboto-Regular"
        case bold = "Roboto-Bold"
        case black = "Roboto-Black"
    }
}

public protocol FontConvertible {
    var rawValue: String { get }
    func size(_ size: CGFloat) -> UIFont
}

public extension FontConvertible {
    func size(_ size: CGFloat) -> UIFont {
        // If crashing, remember to add the fonts in the target membership and info.plist
        return UIFont(name: rawValue, size: size)!
    }
}
