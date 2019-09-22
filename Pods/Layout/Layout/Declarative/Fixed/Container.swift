//
//  Container.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - Container
/// Non leaf node of the layout tree.
///
/// Works the same as `Component` but additionally have sub-component. Use `relative: false` if sub's view is not a subview of this container's view.
public struct Container<View: FrameHolder>: LayoutComponent {
    public let view: View
    public let sub: LayoutComponent
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    public let relative: Bool
    
    public init(
        _ view: View,
        _ h: HorizontalLayoutRule, _ v: VerticalLayoutRule,
        relative: Bool = true, sub: LayoutComponent) {
        
        self.view = view
        self.sub = sub
        self.h = h
        self.v = v
        self.relative = relative
    }
    
    public func performLayout(inFrame frame: CGRect) {
        let containerFrame = layout(LayoutRules(h: h, v: v), inFrame: frame)
        view.frame = containerFrame
        let frame = relative ? containerFrame.bounds : containerFrame
        sub.performLayout(inFrame: frame)
    }
}

// MARK: - VirtualContainer
/// Non leaf node of the layout tree without actual view
public struct VirtualContainer<Sub: LayoutComponent>: LayoutComponent {
    public let sub: Sub
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    
    public init(
        _ h: HorizontalLayoutRule, _ v: VerticalLayoutRule,
        sub: Sub) {
        
        self.sub = sub
        self.h = h
        self.v = v
    }
    
    public func performLayout(inFrame frame: CGRect) {
        let containerFrame = layout(LayoutRules(h: h, v: v), inFrame: frame)
        let frame = containerFrame
        sub.performLayout(inFrame: frame)
    }
}
