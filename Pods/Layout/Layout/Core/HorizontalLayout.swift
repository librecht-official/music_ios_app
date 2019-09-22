//
//  HorizontalLayout.swift
//  Layout
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Fixed-size layout rule describing how to calculate horizontal bounds of the view (x and width)
public enum HorizontalLayoutRule {
    case h1(leading: CGFloat, trailing: CGFloat)
    case h2(leading: CGFloat, width: Length)
    case h3(width: Length, trailing: CGFloat)
    case h4(centerX: Center, width: Length)
    case h5(centerX: Center, leading: CGFloat)
    case h6(centerX: Center, trailing: CGFloat)
    
    public static let zero = HorizontalLayoutRule.h1(leading: 0, trailing: 0)
}

/// Calculates x and width for the "subview" of "bounds"
///
/// Requires only x and width defined in `bounds`.
public func horizontalLayout(
    rule: HorizontalLayoutRule,
    inBounds bounds: CGRect) -> (x: CGFloat, width: CGFloat) {
    
    var x, w: CGFloat
    switch rule {
    case let .h1(leading, trailing):
        x = leading
        w = bounds.width - x - trailing
    case let .h2(leading, width):
        x = leading
        w = width.width(for: bounds)
    case let .h3(width, trailing):
        w = width.width(for: bounds)
        x = bounds.width - trailing - w
    case let .h4(centerX, width):
        w = width.width(for: bounds)
        x = centerX.x(for: bounds) - w / 2
    case let .h5(centerX, leading):
        x = leading
        w = 2 * (centerX.x(for: bounds) - x)
    case let .h6(centerX, trailing):
        let cy = centerX.x(for: bounds)
        w = 2 * (bounds.width - trailing - cy)
        x = cy - w / 2
    }
    return (x, w)
}
