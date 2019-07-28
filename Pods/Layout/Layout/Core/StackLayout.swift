//
//  StackLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 01.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public enum StackItemLength {
    case abs(CGFloat)
    case weight(CGFloat)
    
    func value(totalWeight: CGFloat, totalWeightedLength: CGFloat) -> CGFloat {
        switch self {
        case let .abs(val):
            return val
        case let .weight(w):
            return w / totalWeight * totalWeightedLength
        }
    }
}

public struct StackItem {
    public typealias LayoutOutput = (CGRect) -> ()
    public let output: LayoutOutput
    public let length: StackItemLength
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat
    
    public init(
        _ output: @escaping LayoutOutput, length: StackItemLength,
        top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        
        self.output = output
        self.length = length
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
}

/// Calculates frames for each item in fixed-size stacked column.
///
/// Outputs result via StackItem.output and return value as well.
@discardableResult
public func stackColumn(
    spacing: CGFloat,
    _ items: [StackItem], inFrame frame: CGRect) -> [CGRect] {
    
    let bounds = CGRect(origin: .zero, size: frame.size)
    
    var totalAbsoluteItemsHeight = CGFloat(0)
    var totalWeight = CGFloat(0)
    for item in items {
        switch item.length {
        case let .abs(h):
            totalAbsoluteItemsHeight += (h + item.top + item.bottom)
        case let .weight(w):
            totalAbsoluteItemsHeight += item.top + item.bottom
            totalWeight += w
        }
    }
    totalAbsoluteItemsHeight += spacing * CGFloat(items.count - 1)
    assert(bounds.height >= totalAbsoluteItemsHeight, "total absolute items height (+ top + bottom) \(totalAbsoluteItemsHeight) should be less than or equal to bounds.height \(bounds.height)")
    let heightForWeightedItems = bounds.height - totalAbsoluteItemsHeight
    
    var result = [CGRect]()
    var y = CGFloat(0)
    for item in items {
        let (x, w) = horizontalLayout(
            rule: .h1(leading: item.leading, trailing: item.trailing), inBounds: bounds
        )
        let h = item.length.value(totalWeight: totalWeight, totalWeightedLength: heightForWeightedItems)
        let rect = CGRect(x: x, y: y + item.top, width: w, height: h)
            .offsetBy(dx: frame.origin.x, dy: frame.origin.y)
        item.output(rect)
        result.append(rect)
        y += item.top + h + item.bottom + spacing
    }
    
    return result
}

/// Calculates frames for each item in fixed-size stacked row.
///
/// Outputs result via StackItem.output and return value as well.
@discardableResult
public func stackRow(
    spacing: CGFloat,
    _ items: [StackItem], inFrame frame: CGRect) -> [CGRect] {
    
    let bounds = CGRect(origin: .zero, size: frame.size)
    
    var totalAbsoluteItemsWidth = CGFloat(0)
    var totalWeight = CGFloat(0)
    for item in items {
        switch item.length {
        case let .abs(w):
            totalAbsoluteItemsWidth += (w + item.leading + item.trailing)
        case let .weight(w):
            totalAbsoluteItemsWidth += item.leading + item.trailing
            totalWeight += w
        }
    }
    totalAbsoluteItemsWidth += spacing * CGFloat(items.count - 1)
    assert(bounds.width >= totalAbsoluteItemsWidth, "total absolute items width (+ leading + trailing) \(totalAbsoluteItemsWidth) should be less than or equal to bounds.width \(bounds.width)")
    let widthForWeightedItems = bounds.width - totalAbsoluteItemsWidth
    
    var result = [CGRect]()
    var x = CGFloat(0)
    for item in items {
        // alignment: fill only
        let (y, h) = verticalLayout(
            rule: .v1(top: item.top, bottom: item.bottom), inBounds: bounds
        )
        let w = item.length.value(totalWeight: totalWeight, totalWeightedLength: widthForWeightedItems)
        let rect = CGRect(x: x + item.leading, y: y, width: w, height: h)
            .offsetBy(dx: frame.origin.x, dy: frame.origin.y)
        item.output(rect)
        result.append(rect)
        x += item.leading + w + item.trailing + spacing
    }
    
    return result
}
