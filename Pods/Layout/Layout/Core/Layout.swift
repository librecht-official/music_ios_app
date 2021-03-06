//
//  Layout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 01.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public enum Center {
    /// absolute value in points
    case abs(CGFloat)
    /// value relative to superview
    case rel(CGFloat)
    
    func x(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return bounds.midX + val
        case let .rel(proportion): return bounds.midX * proportion
        }
    }
    
    func y(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return bounds.midY + val
        case let .rel(proportion): return bounds.midY * proportion
        }
    }
}

public enum Length {
    /// Absolute value in points
    case abs(CGFloat)
    /// Value relative to superview
    case rel(CGFloat)
    
    func width(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return val
        case let .rel(proportion): return bounds.width * proportion
        }
    }
    
    func height(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return val
        case let .rel(proportion): return bounds.height * proportion
        }
    }
}

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

/// Calculates x and width for the "subview" of "bounds"
///
/// Requires only x and width defined in `bounds`.
public func horizontalLayout(rule: HorizontalLayoutRule, inBounds bounds: CGRect) -> (x: CGFloat, width: CGFloat) {
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

extension CGRect {
    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}

/// Something that is able to calculate it's height for given width
public protocol HeightAware {
    func size(ifWidth width: CGFloat) -> CGSize
}

/// Something that is able to calculate it's width for given height
public protocol WidthAware {
    func size(ifHeight height: CGFloat) -> CGSize
}

/// Something that is able to calculate it's size for given restricting width and height
public protocol SizeAware: HeightAware, WidthAware {
    func sizeThatFits(_ size: CGSize) -> CGSize
}

public extension SizeAware {
    func size(ifWidth width: CGFloat) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func size(ifHeight height: CGFloat) -> CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height))
    }
}
