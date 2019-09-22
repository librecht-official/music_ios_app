//
//  Component.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - Component
/// Leaf node of the layout tree.
///
/// Basic leaf `LayoutComponent` which calculates frame for it's `frameHolder`.
public struct Component<View: FrameHolder>: LayoutComponent {
    public let view: View
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    
    public init(_ view: View) {
        self.init(view, .zero, .zero)
    }
    
    public init(_ view: View, _ h: HorizontalLayoutRule, _ v: VerticalLayoutRule) {
        self.view = view
        self.h = h
        self.v = v
    }
    
    public func performLayout(inFrame frame: CGRect) {
        view.frame = layout(LayoutRules(h: h, v: v), inFrame: frame)
    }
}
