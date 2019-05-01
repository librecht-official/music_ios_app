//
//  Color.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

enum Color {
    /// #2687FB
    case primaryBlue
    
    /// UIColor.white
    case white
    
    /// #8E8E93
    case lightGrayText
    
    /// #7D7D83
    case jumboGray
    
    /// #EEEEEE
    case altoGray
    
    /// #D8D8D8
    case galleryGray
    
    /// UIColor.lightGray (rgb: 2/3 a: 1)
    case lightGray
    
    /// UIColor(white: 0, alpha: 0.35)
    case gray
    
    /// #0F0F0F
    @available(*, deprecated)
    case blackBackground
    
    /// UIColor.black
    case blackText
    
    /// UIColor.black
    case black
}

extension Color {
    var uiColor: UIColor {
        switch self {
        case .primaryBlue:
            return UIColor(rgb: 0x2687FB)
        case .white:
            return UIColor.white
        case .lightGrayText:
            return UIColor(rgb: 0x8E8E93)
        case .jumboGray:
            return UIColor(rgb: 0x7D7D83)
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
        case .blackText, .black:
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
