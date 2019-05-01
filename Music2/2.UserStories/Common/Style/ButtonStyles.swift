//
//  ButtonStyles.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

struct IconButtonStyle {
    let normalIcon: ImageAsset
    let selectedIcon: ImageAsset?
    let disabledIcon: ImageAsset?
    let tintColor: Color
    let alpha: CGFloat
    
    init(normalIcon: ImageAsset, selectedIcon: ImageAsset? = nil,
         disabledIcon: ImageAsset? = nil, tintColor: Color, alpha: CGFloat = 1) {
        self.normalIcon = normalIcon
        self.selectedIcon = selectedIcon
        self.disabledIcon = disabledIcon
        self.tintColor = tintColor
        self.alpha = alpha
    }
}

extension UIButton {
    func apply(style: IconButtonStyle) {
        setImage(style.normalIcon.image, for: .normal)
        setImage(style.selectedIcon?.image, for: .selected)
        setImage(style.disabledIcon?.image, for: .disabled)
        tintColor = style.tintColor.uiColor
        alpha = style.alpha
    }
}
