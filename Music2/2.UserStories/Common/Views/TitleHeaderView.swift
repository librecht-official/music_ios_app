//
//  TitleHeaderView.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Reusable
import Layout

final class TitleHeaderView: UIView {
    // MARK: Style
    struct Style {
        let backgroundColor = Color.white
        let title = LabelStyle(font: Font.semibold(22), textColor: Color.blackText)
    }
    var style = Style() { didSet { apply(style: style) } }
    func apply(style: Style) {
        backgroundColor = style.backgroundColor.uiColor
        titleLabel.apply(style: style.title)
    }
    
    // MARK: Properties
    
    static let desiredHeight = CGFloat(42)
    
    private let titleLabel = UILabel()
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        apply(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private lazy var layout = Component(
        titleLabel, .h1(leading: 16, trailing: 16), .v1(top: 8, bottom: 8)
    )
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.performLayout(inFrame: bounds)
    }
}

final class TitleTableHeaderView: UITableViewHeaderFooterView, Reusable {
    private let view = TitleHeaderView()
    
    func configure(title: String) {
        view.title = title
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
