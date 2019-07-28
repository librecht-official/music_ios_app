//
//  WidthAwareStackLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 27/07/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public enum FlexibleRowItem {
    case fixed(width: CGFloat, (CGRect) -> ())
    case automatic(WidthAware, (CGRect) -> ())
}

/// Returns calculated width
@discardableResult
public func stackWidthAwareRow(
    spacing: CGFloat,
    _ items: [FlexibleRowItem], inOrigin origin: CGPoint, height: CGFloat) -> CGFloat {
    
    let totalAbsoluteItemsWidth = totalWidthAwareRowWidth(spacing: spacing, items, height: height)
    let bounds = CGRect(x: 0, y: 0, width: totalAbsoluteItemsWidth, height: height)
    
    var x = CGFloat(0)
    for item in items {
        let output: (CGRect) -> ()
        let width: CGFloat
        switch item {
        case let .fixed(w, out):
            output = out
            width = w
        case let .automatic(widthAware, out):
            output = out
            width = widthAware.size(ifHeight: height).width
        }
        
        let (y, h) = (bounds.origin.y, bounds.size.height)
        let w = width
        let rect = CGRect(x: x, y: y, width: w, height: h)
            .offsetBy(dx: origin.x, dy: origin.y)
        output(rect)
        x += w + spacing
    }
    
    return totalAbsoluteItemsWidth
}

/// Returns calculated width
///
/// Does not call FlexibleRowItem output closure.
public func totalWidthAwareRowWidth(
    spacing: CGFloat, _ items: [FlexibleRowItem], height: CGFloat) -> CGFloat {
    
    var totalAbsoluteItemsWidth = CGFloat(0)
    for item in items {
        switch item {
        case let .fixed(w, _):
            totalAbsoluteItemsWidth += w
        case let .automatic(widthAware, _):
            let w = widthAware.size(ifHeight: height).width
            totalAbsoluteItemsWidth += w
        }
    }
    totalAbsoluteItemsWidth += spacing * CGFloat(items.count - 1)
    return totalAbsoluteItemsWidth
}
