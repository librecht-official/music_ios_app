//
//  Color.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

enum Color {
    /// #E73931
    case primaryRed
    /// #FCE38A
    case primaryYellow
    /// #EF3F61
    case primaryPink
    /// UIColor.white
    case white
    /// UIColor.lightGray
    case lightGray
    /// #0F0F0F
    case blackBackground
    /// UIColor.black
    case black
}

extension Color {
    var uiColor: UIColor {
        switch self {
        case .primaryRed:
            return UIColor(rgb: 0xE73931)
        case .primaryYellow:
            return UIColor(rgb: 0xFCE38A)
        case .primaryPink:
            return UIColor(rgb: 0xEF3F61)
        case .white:
            return UIColor.white
        case .lightGray:
            return UIColor.lightGray
        case .blackBackground:
            return UIColor(rgb: 0x0F0F0F)
        case .black:
            return UIColor.black
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
}
