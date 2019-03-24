//
//  Color.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

enum Color {
    /// #FF33FF
    case primaryPurple
    /// #FFFF33
    case primaryYellow
    /// #33FFFF
    case primaryBlue
    
    /// UIColor.white
    case white
    /// #EEEEEE
    case altoGray
    /// #D8D8D8
    case galleryGray
    /// UIColor.lightGray (rgb: 2/3 a: 1)
    case lightGray
    /// UIColor(white: 0, alpha: 0.35)
    case gray
    /// #0F0F0F
    case blackBackground
    /// UIColor.black
    case black
}

extension Color {
    var uiColor: UIColor {
        switch self {
        case .primaryPurple:
            return UIColor(rgb: 0xFF33FF)
        case .primaryYellow:
            return UIColor(rgb: 0xFFFF33)
        case .primaryBlue:
            return UIColor(rgb: 0x33FFFF)
            
        case .white:
            return UIColor.white
        case .altoGray:
            return UIColor(rgb: 0xEEEEEE)
        case .galleryGray:
            return UIColor(rgb: 0xD8D8D8)
        case .lightGray:
            return UIColor.lightGray
        case .gray:
            return UIColor(white: 0, alpha: 0.35)
        case .blackBackground:
            return UIColor(rgb: 0x0F0F0F)
        case .black:
            return UIColor.black
        }
    }
    
    var cgColor: CGColor {
        return uiColor.cgColor
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
