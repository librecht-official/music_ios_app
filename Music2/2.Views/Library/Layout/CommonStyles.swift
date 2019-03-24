//
//  CommonStyles.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import YogaKit

enum Styles {
    enum Common {
        static let container = Layout.Style<UIView>(layout: {
            $0.position = .absolute
            $0.top = 0
            $0.left = 0
            $0.right = 0
            $0.bottom = 0
            $0.justifyContent = .spaceBetween
            $0.alignItems = .stretch
        })
        
        static let scroll = Layout.Style<UIScrollView>(layout: {
            $0.flexGrow = 1
            $0.flexDirection = .column
            $0.justifyContent = .flexStart
            $0.alignItems = .stretch
            $0.overflow = .scroll
        }) {
            $0.alwaysBounceVertical = true
        }
        
        static let content = Layout.Style<UIView>(layout: {
            $0.flexGrow = 1
            $0.flexDirection = .column
            $0.justifyContent = .flexStart
            $0.alignItems = .stretch
        })
    }
}
