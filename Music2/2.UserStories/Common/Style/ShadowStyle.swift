//
//  ShadowStyle.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

struct ShadowStyle {
    let color: Color
    let offset: CGSize
    let radius: CGFloat
    let opacity: CGFloat
    
    init(color: Color = Color.gray, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4, opacity: CGFloat = 1) {
        self.color = color
        self.offset = offset
        self.radius = radius
        self.opacity = opacity
    }
}

extension UIView {
    func applyShadow(style: ShadowStyle) {
        layer.shadowColor = style.color.cgColor
        layer.shadowOffset = style.offset
        layer.shadowRadius = style.radius
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
}
