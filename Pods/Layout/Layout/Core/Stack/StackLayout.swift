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
            guard totalWeight > 0 else { return 0 }
            return w / totalWeight * totalWeightedLength
        }
    }
}

public enum StackDistribution {
    case start, end, evenlySpaced
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

private struct ItemsFramesCalculationInput {
    let spacing: CGFloat
    let items: [StackItem]
    let frame: CGRect
    let occupiedSpace: CGFloat
    let totalWeight: CGFloat
}

// MARK: - stackColumn
/// Calculates frames for each item in fixed-size stacked column.
///
/// If there is no enougn space, items with weighted height will have 0 height.
/// If free space remains and there are weighted items they will occupy this free space.
/// If free space remains and there are **no** weighted items it uses distribution.
/// Outputs result via StackItem.output and return value as well.
@discardableResult
public func stackColumn(
    spacing: CGFloat,
    distribution: StackDistribution,
    _ items: [StackItem], inFrame frame: CGRect) -> [CGRect] {
    
    return stack(
        spacing: spacing, distribution: distribution, items, inFrame: frame,
        lengthAlongMainAxis: { $0.height },
        secondaryAxisLayout: {
            horizontalLayout(rule: .h1(leading: $0.leading, trailing: $0.trailing), inBounds: $1)
        },
        leading: { $0.top }, trailing: { $0.bottom },
        makeRect: { CGRect(x: $1, y: $0, width: $3, height: $2) }
    )
}

// MARK: - stackRow
/// Calculates frames for each item in fixed-size stacked row.
///
/// If there is no enougn space, items with weighted width will have 0 width.
/// If free space remains and there are weighted items they will occupy this free space.
/// If free space remains and there are **no** weighted items it uses distribution.
/// Outputs result via StackItem.output and return value as well.
@discardableResult
public func stackRow(
    spacing: CGFloat,
    distribution: StackDistribution,
    _ items: [StackItem], inFrame frame: CGRect) -> [CGRect] {
    
    return stack(
        spacing: spacing, distribution: distribution, items, inFrame: frame,
        lengthAlongMainAxis: { $0.width },
        secondaryAxisLayout: {
            verticalLayout(rule: .v1(top: $0.top, bottom: $0.bottom), inBounds: $1)
        },
        leading: { $0.leading }, trailing: { $0.trailing },
        makeRect: { CGRect(x: $0, y: $1, width: $2, height: $3) }
    )
}

// MARK: - Axis independent stack calculation

private func stack(
    spacing: CGFloat, distribution: StackDistribution,
    _ items: [StackItem], inFrame frame: CGRect,
    lengthAlongMainAxis: (CGRect) -> CGFloat,
    secondaryAxisLayout: (StackItem, CGRect) -> (CGFloat, CGFloat),
    leading: (StackItem) -> CGFloat, trailing: (StackItem) -> CGFloat,
    makeRect: (CGFloat, CGFloat, CGFloat, CGFloat) -> CGRect) -> [CGRect] {
    
    var occupiedSpace = CGFloat(0)
    var totalWeight = CGFloat(0)
    var haveWeightedItem = false
    for item in items {
        switch item.length {
        case let .abs(len):
            occupiedSpace += (len + leading(item) + trailing(item))
        case let .weight(weight):
            haveWeightedItem = true
            occupiedSpace += leading(item) + trailing(item)
            totalWeight += weight
        }
    }
    occupiedSpace += spacing * CGFloat(items.count - 1)
    
    let input = ItemsFramesCalculationInput(
        spacing: spacing,
        items: items,
        frame: frame,
        occupiedSpace: occupiedSpace,
        totalWeight: totalWeight
    )
    
    if haveWeightedItem {
        return calculateItemsFramesWithFixedSpacings(
            input, start: 0, lengthAlongMainAxis: lengthAlongMainAxis,
            secondaryAxisLayout: secondaryAxisLayout,
            leading: leading, trailing: trailing,
            makeRect: makeRect
        )
    }
    switch distribution {
    case .start:
        return calculateItemsFramesWithFixedSpacings(
            input, start: 0, lengthAlongMainAxis: lengthAlongMainAxis,
            secondaryAxisLayout: secondaryAxisLayout,
            leading: leading, trailing: trailing,
            makeRect: makeRect
        )
    case .end:
        let start = lengthAlongMainAxis(frame) - occupiedSpace
        return calculateItemsFramesWithFixedSpacings(
            input, start: start, lengthAlongMainAxis: lengthAlongMainAxis,
            secondaryAxisLayout: secondaryAxisLayout,
            leading: leading, trailing: trailing,
            makeRect: makeRect
        )
    case .evenlySpaced:
        return calculateItemsFramesForEvenlySpacedRowDistribution(
            input, lengthAlongMainAxis: lengthAlongMainAxis,
            secondaryAxisLayout: secondaryAxisLayout,
            leading: leading, trailing: trailing,
            makeRect: makeRect
        )
    }
}

private func calculateItemsFramesWithFixedSpacings(
    _ input: ItemsFramesCalculationInput, start: CGFloat,
    lengthAlongMainAxis: (CGRect) -> CGFloat,
    secondaryAxisLayout: (StackItem, CGRect) -> (CGFloat, CGFloat),
    leading: (StackItem) -> CGFloat, trailing: (StackItem) -> CGFloat,
    makeRect: (CGFloat, CGFloat, CGFloat, CGFloat) -> CGRect) -> [CGRect] {
    
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, lengthAlongMainAxis(bounds) - input.occupiedSpace)
    
    var result = [CGRect]()
    var x = start
    for item in input.items {
        let (y, h) = secondaryAxisLayout(item, bounds)
        let w = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        let rect = makeRect(x + leading(item), y, w, h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        x += leading(item) + w + trailing(item) + input.spacing
    }
    
    return result
}

private func calculateItemsFramesForEvenlySpacedRowDistribution(
    _ input: ItemsFramesCalculationInput,
    lengthAlongMainAxis: (CGRect) -> CGFloat,
    secondaryAxisLayout: (StackItem, CGRect) -> (CGFloat, CGFloat),
    leading: (StackItem) -> CGFloat, trailing: (StackItem) -> CGFloat,
    makeRect: (CGFloat, CGFloat, CGFloat, CGFloat) -> CGRect) -> [CGRect] {
    
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, lengthAlongMainAxis(bounds) - input.occupiedSpace)
    
    guard input.items.count > 0 else { return [] }
    let numberOfSpacings = input.items.count - 1
    let d = numberOfSpacings != 0 ? numberOfSpacings : 1
    let spacing = input.spacing + freeSpace / CGFloat(d)
    
    var result = [CGRect]()
    var x = CGFloat(0)
    for item in input.items {
        let (y, h) = secondaryAxisLayout(item, bounds)
        let w = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        let rect = makeRect(x + leading(item), y, w, h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        x += leading(item) + w + trailing(item) + spacing
    }
    
    return result
}
