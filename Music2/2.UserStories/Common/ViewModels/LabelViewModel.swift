//
//  LabelViewModel.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation
import CoreGraphics

struct LabelViewModel {
    let text: String
    let font: Font
    
    func boundingRect(width: CGFloat) -> CGRect {
        return (text as NSString).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font : font.uiFont],
            context: nil
        )
    }
}
