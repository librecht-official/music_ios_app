//
//  AspectRatioComponent.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - AspectRatioComponent
/// Leaf node of the layout tree with aspect ratio layout rule.
///
/// Leaf `LayoutComponent` which calculates frame for it's `frameHolder` using special aspect ratio layout rule.
public struct AspectRatioComponent<View: FrameHolder>: LayoutComponent {
    public let view: View
    public let ratio: CGFloat
    public let suplementingRule: AspectRatioSupplementingLayoutRule
    
    public init(
        _ view: View,
        ratio: CGFloat,
        _ suplementingRule: AspectRatioSupplementingLayoutRule) {
        
        self.view = view
        self.ratio = ratio
        self.suplementingRule = suplementingRule
    }
    
    public func performLayout(inFrame frame: CGRect) {
        view.frame = layout(aspectRatio: ratio, suplementingRule, inFrame: frame)
    }
}
