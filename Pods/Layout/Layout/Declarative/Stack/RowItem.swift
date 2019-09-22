//
//  RowItem.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - FitWidthAwareLayoutComponent
public typealias FitWidthAwareLayoutComponent = LayoutComponent & WidthAware

// MARK: - RowItem
public enum RowItem {
    // Fixed-size
    case fixed(width: StackItemLength, LayoutComponent, Insets)
    
    public static func fixed(width: StackItemLength, _ c: LayoutComponent) -> RowItem {
        return .fixed(width: width, c, .zero)
    }
    
    // Less than
    case lessThanOrEqual(CGFloat, FitWidthAwareLayoutComponent, Insets)
    
    public static func lessThanOrEqual(_ max: CGFloat, _ c: FitWidthAwareLayoutComponent) -> RowItem {
        return .lessThanOrEqual(max, c, .zero)
    }
    
    // More than
    case moreThanOrEqual(CGFloat, FitWidthAwareLayoutComponent, Insets)
    
    public static func moreThanOrEqual(_ min: CGFloat, _ c: FitWidthAwareLayoutComponent) -> RowItem {
        return .moreThanOrEqual(min, c, .zero)
    }
    
    // More than & Less than
    case inBetween(CGFloat, CGFloat, FitWidthAwareLayoutComponent, Insets)
    
    public static func inBetween(_ min: CGFloat, max: CGFloat, _ c: FitWidthAwareLayoutComponent) -> RowItem {
        return .inBetween(min, max, c, .zero)
    }
    
    // Aspect ratio
    case aspectRatio(CGFloat, LayoutComponent, Insets)
    
    public static func aspectRatio(_ r: CGFloat, _ c: LayoutComponent) -> RowItem {
        return .aspectRatio(r, c, .zero)
    }
}

extension RowItem {
    var sub: LayoutComponent {
        switch self {
        case let .fixed(_, component, _):
            return component
        case let .lessThanOrEqual(_, component, _):
            return component
        case let .moreThanOrEqual(_, component, _):
            return component
        case let .inBetween(_, _, component, _):
            return component
        case let .aspectRatio(_, component, _):
            return component
        }
    }
    
    func width(ifStackHeight height: CGFloat) -> StackItemLength {
        switch self {
        case let .fixed(width, _, _):
            return width
        case let .lessThanOrEqual(maxWidth, component, insets):
            let adjustedHeight = height - insets.topPlusBottom
            let componentWidth = component.size(ifHeight: adjustedHeight).width
            let width = min(componentWidth, maxWidth)
            return .abs(width)
        case let .moreThanOrEqual(minWidth, component, insets):
            let adjustedHeight = height - insets.topPlusBottom
            let componentWidth = component.size(ifHeight: adjustedHeight).width
            let width = max(componentWidth, minWidth)
            return .abs(width)
        case let .inBetween(minWidth, maxWidth, component, insets):
            let adjustedHeight = height - insets.topPlusBottom
            let componentWidth = component.size(ifHeight: adjustedHeight).width
            let width = min(max(componentWidth, minWidth), maxWidth)
            return .abs(width)
        case let .aspectRatio(ratio, _, insets):
            let adjustedHeight = height - insets.topPlusBottom
            let width = ratio * adjustedHeight
            return .abs(width)
        }
    }
    
    var insets: Insets {
        switch self {
        case let .fixed(_, _, insets),
             let .lessThanOrEqual(_, _, insets),
             let .moreThanOrEqual(_, _, insets),
             let .inBetween(_, _, _, insets),
             let .aspectRatio(_, _, insets):
            return insets
        }
    }
}
