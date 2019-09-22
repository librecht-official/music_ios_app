//
//  ColumnItem.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - FitHeightAwareLayoutComponent
public typealias FitHeightAwareLayoutComponent = LayoutComponent & HeightAware

// MARK: - ColumnItem
public enum ColumnItem {
    // Fixed-size
    case fixed(height: StackItemLength, LayoutComponent, Insets)
    
    public static func fixed(height: StackItemLength, _ c: LayoutComponent) -> ColumnItem {
        return .fixed(height: height, c, .zero)
    }
    
    // Less than
    case lessThanOrEqual(CGFloat, FitHeightAwareLayoutComponent, Insets)
    
    public static func lessThanOrEqual(_ max: CGFloat, c: FitHeightAwareLayoutComponent) -> ColumnItem {
        return .lessThanOrEqual(max, c, .zero)
    }
    
    // More than
    case moreThanOrEqual(CGFloat, FitHeightAwareLayoutComponent, Insets)
    
    public static func moreThanOrEqual(_ min: CGFloat, _ c: FitHeightAwareLayoutComponent) -> ColumnItem {
        return .moreThanOrEqual(min, c, .zero)
    }
    
    // More than & Less than
    case inBetween(CGFloat, CGFloat, FitHeightAwareLayoutComponent, Insets)
    
    public static func inBetween(_ min: CGFloat, max: CGFloat, _ c: FitHeightAwareLayoutComponent) -> ColumnItem {
        return .inBetween(min, max, c, .zero)
    }
    
    // Aspect ratio
    case aspectRatio(CGFloat, LayoutComponent, Insets)
    
    public static func aspectRatio(_ r: CGFloat, _ c: LayoutComponent) -> ColumnItem {
        return .aspectRatio(r, c, .zero)
    }
}

extension ColumnItem {
    var sub: LayoutComponent {
        switch self {
        case let .fixed(height: _, component, _):
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
    
    func height(ifStackWidth width: CGFloat) -> StackItemLength {
        switch self {
        case let .fixed(height, _, _):
            return height
        case let .lessThanOrEqual(maxHeight, component, insets):
            let adjustedWidth = width - insets.leadingPlusTrailing
            let componentHeight = component.size(ifWidth: adjustedWidth).height
            let height = min(componentHeight, maxHeight)
            return .abs(height)
        case let .moreThanOrEqual(minWidth, component, _):
            let adjustedWidth = width - insets.leadingPlusTrailing
            let componentHeight = component.size(ifWidth: adjustedWidth).height
            let width = max(componentHeight, minWidth)
            return .abs(width)
        case let .inBetween(minWidth, maxWidth, component, _):
            let adjustedWidth = width - insets.leadingPlusTrailing
            let componentHeight = component.size(ifWidth: adjustedWidth).height
            let width = min(max(componentHeight, minWidth), maxWidth)
            return .abs(width)
        case let .aspectRatio(ratio, _, _):
            let adjustedWidth = width - insets.leadingPlusTrailing
            let height = adjustedWidth / ratio
            return .abs(height)
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
