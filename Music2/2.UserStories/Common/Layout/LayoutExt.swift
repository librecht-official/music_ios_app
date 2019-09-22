//
//  LayoutExt.swift
//  Music2
//
//  Created by Vladislav Librecht on 28/07/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Layout

/// Leaf node of the layout tree with aspect ratio layout rule.
///
/// Leaf `LayoutComponent` which calculates frame for it's `frameHolder` using special aspect ratio layout rule.
public struct AspectRatioComponent: LayoutComponent {
    public let frameHolder: FrameHolder
    public let ratio: CGFloat
    public let suplementingRule: AspectRatioSupplementingLayoutRule
    
    public init(
        _ frameHolder: FrameHolder,
        ratio: CGFloat,
        _ suplementingRule: AspectRatioSupplementingLayoutRule) {
        
        self.frameHolder = frameHolder
        self.ratio = ratio
        self.suplementingRule = suplementingRule
    }
    
    public func performLayout(inFrame frame: CGRect) {
        frameHolder.frame = layout(aspectRatio: ratio, suplementingRule, inFrame: frame)
    }
}
