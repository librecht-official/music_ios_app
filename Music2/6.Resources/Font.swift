//
//  Font.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

enum Font {
    /// system 36, bold
    case barTitle
    /// system regular 17
    case regularCaption
    /// system regular 14
    case smallCaption
    /// system bold
    case bold(Float)
}

extension Font {
    var uiFont: UIFont {
        switch self {
        case .barTitle:
            return UIFont.systemFont(ofSize: 36, weight: .bold)
        case .regularCaption:
            return UIFont.systemFont(ofSize: 17)
        case .smallCaption:
            return UIFont.systemFont(ofSize: 14)
        case .bold(let size):
            return UIFont.systemFont(ofSize: CGFloat(size), weight: .bold)
        }
    }
}
