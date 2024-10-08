//
//  TCMPPExtension.swift
//  TCMPPDemo-Swift
//
//  Created by gavinjwxu on 2024/8/13.
//

import UIKit

extension String {
    var hexValue: UInt32 {
        return UInt32(self, radix: 16) ?? 0
    }
}

extension UIColor {
    static func tcmpp_color(withHex hex: String) -> UIColor {
        var hex = hex
        if hex == "" {
            return UIColor.clear
        }
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        } else if hex.hasPrefix("0x") {
            hex = String(hex.dropFirst(2))
        }
        let length = hex.count
        if length != 3 && length != 6 && length != 8 {
            return UIColor.clear
        }
        if length == 3 {
            let r = String(hex[hex.index(hex.startIndex, offsetBy: 0)])
            let g = String(hex[hex.index(hex.startIndex, offsetBy: 1)])
            let b = String(hex[hex.index(hex.startIndex, offsetBy: 2)])
            hex = r + r + g + g + b + b + "ff"
        } else if length == 6 {
            hex = hex + "ff"
        }
        let red = CGFloat(String(hex[hex.index(hex.startIndex, offsetBy: 0)..<hex.index(hex.startIndex, offsetBy: 2)]).hexValue) / 255.0
        let green = CGFloat(String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)]).hexValue) / 255.0
        let blue = CGFloat(String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)]).hexValue) / 255.0
        let alpha = CGFloat(String(hex[hex.index(hex.startIndex, offsetBy: 6)..<hex.index(hex.startIndex, offsetBy: 8)]).hexValue) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func tcmpp_color(withHex hex: String, alpha: CGFloat) -> UIColor {
        var hex = hex
        if hex == "" {
            return UIColor.clear
        }
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        } else if hex.hasPrefix("0x") {
            hex = String(hex.dropFirst(2))
        }
        let length = hex.count
        if length != 3 && length != 6 && length != 8 {
            return UIColor.clear
        }
        if length == 3 {
            let r = String(hex[hex.index(hex.startIndex, offsetBy: 0)])
            let g = String(hex[hex.index(hex.startIndex, offsetBy: 1)])
            let b = String(hex[hex.index(hex.startIndex, offsetBy: 2)])
            hex = r + r + g + g + b + b + "ff"
        }
        let red = CGFloat(String(hex[hex.index(hex.startIndex, offsetBy: 0)..<hex.index(hex.startIndex, offsetBy: 1)]).hexValue) / 255.0
        let green = CGFloat(String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 3)]).hexValue) / 255.0
        let blue = CGFloat(String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 5)]).hexValue) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIView {
    func roundingCorners(_ corner: UIRectCorner, cornerRadius: CGFloat) {
        let radio = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: radio)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.layer.layoutIfNeeded()
    }
}
