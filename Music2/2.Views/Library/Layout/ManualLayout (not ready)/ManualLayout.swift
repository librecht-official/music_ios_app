//
//  ManualLayout.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

enum ManualLayout {
    enum VerticalLayout {
        case v1(top: CGFloat, bottom: CGFloat)
        case v2(top: CGFloat, height: CGFloat)
        case v3(bottom: CGFloat, height: CGFloat)
    }
    
    enum HorizontalLayout {
        case h1(leading: CGFloat, trailing: CGFloat)
        case h2(leading: CGFloat, width: CGFloat)
        case h3(trailing: CGFloat, width: CGFloat)
    }
    
    struct FixedLayout {
        let vertical: VerticalLayout
        let horizontal: HorizontalLayout
    }
    // FlexibleLayout
    
    /// Does not takes into account right to left reading direction for now
    func layout(_ view: UIView, _ desc: FixedLayout, inside container: UIView? = nil) {
        let _container = container ?? view.superview
        guard let container = _container else {
            print("\(view) passed to layout having no superview")
            return
        }
        
        var x, y, w, h: CGFloat
        switch desc.vertical {
        case let .v1(top, bottom):
            y = top
            h = container.bounds.height - top - bottom
        case let .v2(top, height):
            y = top
            h = height
        case let .v3(bottom, height):
            y = container.bounds.height - bottom - height
            h = height
        }
        switch desc.horizontal {
        case let .h1(leading, trailing):
            x = leading
            w = container.bounds.width - leading - trailing
        case let .h2(leading, width):
            x = leading
            w = width
        case let .h3(trailing, width):
            x = container.bounds.width - trailing - width
            w = width
        }
        let rect = CGRect(x: x, y: y, width: w, height: h)
        view.frame = rect
    }
}

/**
 Usage example:
 
 ```
    func layoutSubviews() {
        layout(topView, FixedLayout(
            vertical: .v2(top: 0, height: 64),
            horizontal: .h1(leading: 0, trailing: 0)
        ))
        topView.layoutIfNeeded()
        layout(scrollView, FixedLayout(
            vertical: .v1(top: topView.frame.height, bottom: 0),
            horizontal: .h1(leading: 0, trailing: 0)
        ))
        var totalWidth = CGFloat(0)
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            let w = view.bounds.width
            layout(view, FixedLayout(
                vertical: .v1(top: 0, bottom: 0),
                horizontal: .h2(leading: CGFloat(i) * w, width: w)
            ))
            totalWidth += w
        }
        layout(stackView, FixedLayout(
            vertical: .v1(top: 0, bottom: 0),
            horizontal: .h2(leading: 0, width: totalWidth)
        ))
        scrollView.contentSize = stackView.bounds.size
    }
 ```
 */
