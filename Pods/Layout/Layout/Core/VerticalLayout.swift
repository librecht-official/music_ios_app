//
//  VerticalLayout.swift
//  Layout
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Fixed-size layout rule describing how to calculate vertical bounds of the view (y and height)
public enum VerticalLayoutRule {
    /// Top and bottom insets
    case v1(top: CGFloat, bottom: CGFloat)
    /// Top inset and height
    case v2(top: CGFloat, height: Length)
    /// Height and bottom inset
    case v3(height: Length, bottom: CGFloat)
    /// Y-center and height
    case v4(centerY: Center, height: Length)
    /// Y-center and top inset
    case v5(centerY: Center, top: CGFloat)
    /// Y-center and bottom inset
    case v6(centerY: Center, bottom: CGFloat)
    
    public static let zero = VerticalLayoutRule.v1(top: 0, bottom: 0)
}

/// Calculates y and height for the "subview" of "bounds"
///
/// Requires only y and height defined in `bounds`.
public func verticalLayout(rule: VerticalLayoutRule, inBounds bounds: CGRect) -> (y: CGFloat, height: CGFloat) {
    let y, h: CGFloat
    switch rule {
    case let .v1(top, bottom):
        y = top
        h = bounds.height - top - bottom
    case let .v2(top, height):
        y = top
        h = height.height(for: bounds)
    case let .v3(height, bottom):
        h = height.height(for: bounds)
        y = bounds.height - bottom - h
    case let .v4(centerY, height):
        h = height.height(for: bounds)
        y = centerY.y(for: bounds) - h / 2
    case let .v5(centerY, top):
        y = top
        h = 2 * (centerY.y(for: bounds) - top)
    case let .v6(centerY, bottom):
        let cy = centerY.y(for: bounds)
        h = 2 * (bounds.height - bottom - cy)
        y = cy - h / 2
    }
    return (y, h)
}
