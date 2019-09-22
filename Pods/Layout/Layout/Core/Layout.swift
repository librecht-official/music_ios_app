//
//  Layout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 01.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Fixed-size layout rule
public struct LayoutRules {
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    
    public init(h: HorizontalLayoutRule, v: VerticalLayoutRule) {
        self.h = h
        self.v = v
    }
}

/// Assumes bounds.origin == { 0, 0 }
public func layout(_ rules: LayoutRules, inBounds bounds: CGRect) -> CGRect {
    let (x, w) = horizontalLayout(rule: rules.h, inBounds: bounds)
    let (y, h) = verticalLayout(rule: rules.v, inBounds: bounds)
    return CGRect(x: x, y: y, width: w, height: h)
}

/// Assumes bounds.origin might not be == { 0, 0 }
public func layout(_ rules: LayoutRules, inFrame frame: CGRect) -> CGRect {
    return layout(rules, inBounds: frame.bounds).offsetBy(dx: frame.origin.x, dy: frame.origin.y)
}

extension CGRect {
    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}
