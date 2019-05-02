//
//  GenresView.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

final class GenresView: UIView {
    struct Style {
        let label = LabelStyle(font: Font.medium(12), textColor: Color.white, alignment: .center)
        let backgroundColor = Color.jumboGray
        let cornerRadius = CGFloat(4)
    }
    var style: Style = Style() {
        didSet {
            apply(style: style)
        }
    }
    func apply(style: Style) {
        label.apply(style: style.label)
        backgroundColor = style.backgroundColor.uiColor
        layer.cornerRadius = style.cornerRadius
    }
    var text: String {
        get { return label.text ?? "" }
        set { label.text = newValue }
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        apply(style: style)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = layout(
            LayoutRules(h: .h1(leading: 6, trailing: 6), v: .v1(top: 3, bottom: 3)),
            inBounds: bounds
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
