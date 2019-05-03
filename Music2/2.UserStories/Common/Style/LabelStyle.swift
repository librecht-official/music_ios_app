//
//  LabelStyle.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

struct LabelStyle {
    let font: Font
    let textColor: Color
    var alignment: NSTextAlignment
    
    init(font: Font, textColor: Color, alignment: NSTextAlignment = .natural) {
        self.font = font
        self.textColor = textColor
        self.alignment = alignment
    }
}
extension UILabel {
    func apply(style: LabelStyle) {
        font = style.font.uiFont
        textColor = style.textColor.uiColor
        textAlignment = style.alignment
        adjustsFontSizeToFitWidth = true
    }
}
