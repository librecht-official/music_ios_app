//
//  AspectRatioLayout.swift
//  Layout
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Fixed-size layout rule describing how to calculate bounds of the view with known aspect ratio
public enum AspectRatioSupplementingLayoutRule {
    public enum HSupplement {
        case top(CGFloat)
        case bottom(CGFloat)
        case centerY(Center)
    }
    case h(HorizontalLayoutRule, and: HSupplement)
    
    public enum VSupplement {
        case leading(CGFloat)
        case trailing(CGFloat)
        case centerX(Center)
    }
    case v(VerticalLayoutRule, and: VSupplement)
}

/// Assumes bounds.origin == { 0, 0 }. aspectRatio = width / height
public func layout(aspectRatio: CGFloat, _ sup: AspectRatioSupplementingLayoutRule, inBounds bounds: CGRect) -> CGRect {
    switch sup {
    case let .h(hRule, and: hSup):
        let (x, w) = horizontalLayout(rule: hRule, inBounds: bounds)
        let absH = w / aspectRatio
        let y, h: CGFloat
        switch hSup {
        case let .top(top):
            (y, h) = verticalLayout(rule: .v2(top: top, height: .abs(absH)), inBounds: bounds)
        case let .bottom(bottom):
            (y, h) = verticalLayout(rule: .v3(height: .abs(absH), bottom: bottom), inBounds: bounds)
        case let .centerY(centerY):
            (y, h) = verticalLayout(rule: .v4(centerY: centerY, height: .abs(absH)), inBounds: bounds)
        }
        return CGRect(x: x, y: y, width: w, height: h)
    case let .v(vRule, and: vSup):
        let (y, h) = verticalLayout(rule: vRule, inBounds: bounds)
        let absW = h * aspectRatio
        let x, w: CGFloat
        switch vSup {
        case let .leading(leading):
            (x, w) = horizontalLayout(rule: .h2(leading: leading, width: .abs(absW)), inBounds: bounds)
        case let .trailing(trailing):
            (x, w) = horizontalLayout(rule: .h3(width: .abs(absW), trailing: trailing), inBounds: bounds)
        case let .centerX(centerX):
            (x, w) = horizontalLayout(rule: .h4(centerX: centerX, width: .abs(absW)), inBounds: bounds)
        }
        return CGRect(x: x, y: y, width: w, height: h)
    }
}

/// Assumes bounds.origin might not be == { 0, 0 }. aspectRatio = width / height
public func layout(aspectRatio: CGFloat, _ sup: AspectRatioSupplementingLayoutRule, inFrame frame: CGRect) -> CGRect {
    return layout(aspectRatio: aspectRatio, sup, inBounds: frame.bounds).offsetBy(dx: frame.origin.x, dy: frame.origin.y)
}
