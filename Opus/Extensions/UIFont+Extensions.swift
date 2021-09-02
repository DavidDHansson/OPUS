//
//  UIFont+Extensions.swift
//  Ticker
//
//  Created by David Hansson on 26/02/2021.
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

extension Font {
    public enum SanFranciscoDisplay: String, FontConvertible {
        case medium = "SanFranciscoDisplay-Medium"
        case regular = "SanFranciscoDisplay-Regular"
        case bold = "SanFranciscoDisplay-Bold"
        case heavy = "SanFranciscoDisplay-Heavy"
        case black = "SanFranciscoDisplay-Black"
        case italic = "SanFranciscoDisplay-Italic"
    }
}

extension Font {
    public enum SairaExtraCondensed: String, FontConvertible {
        case regular = "SairaExtraCondensed-Regular"
        case semiBold = "SairaExtraCondensed-SemiBold"
        case bold = "SairaExtraCondensed-Bold"
    }
}

extension Font {
    public enum SanFrancisco: String, FontConvertible {
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
    }
}

extension Font.SanFrancisco {
    public func size(_ size: CGFloat) -> UIFont {
        switch self {
        case .light:
            return .systemFont(ofSize: size, weight: UIFont.Weight.light)
        case .regular:
            return .systemFont(ofSize: size, weight: UIFont.Weight.regular)
        case .medium:
            return .systemFont(ofSize: size, weight: UIFont.Weight.medium)
        case .semibold:
            return .systemFont(ofSize: size, weight: UIFont.Weight.semibold)
        case .bold:
            return .systemFont(ofSize: size, weight: UIFont.Weight.bold)
        case .heavy:
            return .systemFont(ofSize: size, weight: UIFont.Weight.heavy)
        case .black:
            return .systemFont(ofSize: size, weight: UIFont.Weight.black)
        }
    }
}

public protocol FontConvertible {
    var rawValue: String { get }
    func size(_ size: CGFloat) -> UIFont
}

public extension FontConvertible {
    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: size)!
    }
}
