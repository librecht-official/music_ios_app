//
//  Font.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

enum Font {
    // system 36, bold
    case barTitle
    // system bold
    case bold(Float)
}

extension Font {
    var uiFont: UIFont {
        switch self {
        case .barTitle:
            return UIFont.systemFont(ofSize: 36, weight: .bold)
        case .bold(let size):
            return UIFont.systemFont(ofSize: CGFloat(size), weight: .bold)
        }
    }
}
