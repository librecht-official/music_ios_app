//
//  DeclarativeLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 09.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public protocol FrameHolder: AnyObject {
    var frame: CGRect { get set }
}

public protocol LayoutComponent {
    func performLayout(inFrame frame: CGRect)
}

/// Leaf node of the layout tree.
///
/// Basic leaf `LayoutComponent` which calculates frame for it's `frameHolder`.
public struct Component: LayoutComponent {
    public let frameHolder: FrameHolder
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    
    public init(_ frameHolder: FrameHolder, _ h: HorizontalLayoutRule, _ v: VerticalLayoutRule) {
        self.frameHolder = frameHolder
        self.h = h
        self.v = v
    }
    
    public func performLayout(inFrame frame: CGRect) {
        frameHolder.frame = layout(LayoutRules(h: h, v: v), inFrame: frame)
    }
}

/// Non leaf node of the layout tree.
///
/// Works the same as `Component` but additionally have sub-component. Use `relative: false` if inner's view is not a subview of this container's view, e.g. if `frameHolder` is `nil`.
public struct Container: LayoutComponent {
    public let frameHolder: FrameHolder?
    public let inner: LayoutComponent
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    public let relative: Bool
    
    public init(
        _ frameHolder: FrameHolder? = nil,
        h: HorizontalLayoutRule, v: VerticalLayoutRule,
        relative: Bool = true, inner: LayoutComponent) {
        
        self.frameHolder = frameHolder
        self.inner = inner
        self.h = h
        self.v = v
        self.relative = relative
    }
    
    public func performLayout(inFrame frame: CGRect) {
        let containerFrame = layout(LayoutRules(h: h, v: v), inFrame: frame)
        frameHolder?.frame = containerFrame
        let frame = relative ? containerFrame.bounds : containerFrame 
        inner.performLayout(inFrame: frame)
    }
}

/// Convenience empty leaf node of the layout tree.
///
/// Usefull to describe empty (placeholder) spaces inside stack layout.
public struct EmptyComponent: LayoutComponent {
    public init() {
    }
    
    public func performLayout(inFrame frame: CGRect) {
    }
}

public struct StackComponentItem {
    public let inner: LayoutComponent
    public let length: StackItemLength
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat
    
    public init(
        _ inner: LayoutComponent,
        length: StackItemLength,
        top: CGFloat = 0, bottom: CGFloat = 0,
        leading: CGFloat = 0, trailing: CGFloat = 0) {
        
        self.inner = inner
        self.length = length
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
}

struct Stack: LayoutComponent {
    typealias LayoutFunction = (CGFloat, [StackItem], CGRect) -> [CGRect]
    let spacing: CGFloat, items: [StackComponentItem]
    let layoutFunction: LayoutFunction
    
    init(spacing: CGFloat, _ items: [StackComponentItem], layoutFunction: @escaping LayoutFunction) {
        self.spacing = spacing
        self.items = items
        self.layoutFunction = layoutFunction
    }
    
    func performLayout(inFrame frame: CGRect) {
        _ = layoutFunction(
            spacing, items.map { item -> StackItem in
                return StackItem(
                    {
                        item.inner.performLayout(inFrame: $0)
                    },
                    length: item.length, top: item.top, bottom: item.bottom,
                    leading: item.leading, trailing: item.trailing
                )
            },
            frame
        )
    }
}

/// Item for `Column` that allows to specify height and extra insets
public typealias ColumnItem = StackComponentItem

/// Vertical fixed-size stack
public struct Column: LayoutComponent {
    public let spacing: CGFloat, items: [ColumnItem]
    let stack: Stack
    
    public init(spacing: CGFloat, _ items: [ColumnItem]) {
        self.spacing = spacing
        self.items = items
        self.stack = Stack(spacing: spacing, items, layoutFunction: stackColumn)
    }
    
    public func performLayout(inFrame frame: CGRect) {
        stack.performLayout(inFrame: frame)
    }
}

/// Item for Row that allows to specify width and extra insets
public typealias RowItem = StackComponentItem

/// Horizontal fixed-size stack
public struct Row: LayoutComponent {
    public let spacing: CGFloat, items: [RowItem]
    let stack: Stack
    
    public init(spacing: CGFloat, _ items: [RowItem]) {
        self.spacing = spacing
        self.items = items
        self.stack = Stack(spacing: spacing, items, layoutFunction: stackRow)
    }
    
    public func performLayout(inFrame frame: CGRect) {
        stack.performLayout(inFrame: frame)
    }
}
