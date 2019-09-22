//
//  HeightAwareStackLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 14/07/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public enum FlexibleColumnItem {
    case fixed(height: CGFloat, (CGRect) -> ())
    case automatic(HeightAware, (CGRect) -> ())
}

/// Returns calculated height
@discardableResult
public func stackHeightAwareColumn(
    spacing: CGFloat,
    _ items: [FlexibleColumnItem], inOrigin origin: CGPoint, width: CGFloat) -> CGFloat {
    
    let totalAbsoluteItemsHeight = totalHeightAwareColumnHeight(
        spacing: spacing, items, width: width
    )
    let bounds = CGRect(x: 0, y: 0, width: width, height: totalAbsoluteItemsHeight)
    
    var y = CGFloat(0)
    for item in items {
        let output: (CGRect) -> ()
        let height: CGFloat
        switch item {
        case let .fixed(h, out):
            output = out
            height = h
        case let .automatic(heightAware, out):
            output = out
            height = heightAware.size(ifWidth: width).height
        }
        
        let (x, w) = (bounds.origin.x, bounds.size.width)
        let h = height
        let rect = CGRect(x: x, y: y, width: w, height: h)
            .offsetBy(dx: origin.x, dy: origin.y)
        output(rect)
        y += h + spacing
    }
    
    return totalAbsoluteItemsHeight
}

/// Returns calculated height.
///
/// Does not call FlexibleColumnItem output closure.
public func totalHeightAwareColumnHeight(
    spacing: CGFloat, _ items: [FlexibleColumnItem], width: CGFloat) -> CGFloat {
    
    var totalAbsoluteItemsHeight = CGFloat(0)
    for item in items {
        switch item {
        case let .fixed(h, _):
            totalAbsoluteItemsHeight += h
        case let .automatic(heightAware, _):
            let h = heightAware.size(ifWidth: width).height
            totalAbsoluteItemsHeight += h
        }
    }
    totalAbsoluteItemsHeight += spacing * CGFloat(items.count - 1)
    return totalAbsoluteItemsHeight
}
