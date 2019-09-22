//
//  HeightAwareContainer.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Wrapper-component for Container of HeightAware
public struct HeightAwareContainer: HeightAwareLayoutComponent {
    public let frameHolder: FrameHolder?
    public let sub: HeightAwareLayoutComponent
    public let h: HorizontalLayoutRule
    public let top, bottom: CGFloat
    public let relative: Bool
    
    public init(
        _ frameHolder: FrameHolder?,
        h: HorizontalLayoutRule, top: CGFloat, bottom: CGFloat,
        relative: Bool = true, sub: HeightAwareLayoutComponent) {
        
        self.frameHolder = frameHolder
        self.sub = sub
        self.h = h
        self.top = top
        self.bottom = bottom
        self.relative = relative
    }
    
    public func performLayout(inOrigin origin: CGPoint, width: CGFloat) -> CGFloat {
        // selfHeight is sub's height
        let horizontalBounds = CGRect(origin: origin, size: CGSize(width: width, height: 0))
        let (x1, selfWidth) = horizontalLayout(rule: h, inBounds: horizontalBounds)
        let selfX = origin.x + x1
        let selfY = origin.y + top
        let subOrigin = relative ? CGPoint(x: 0, y: 0) : CGPoint(x: selfX, y: selfY)
        let subTotalHeight = sub.performLayout(inOrigin: subOrigin, width: selfWidth)
        let selfHeight = subTotalHeight
        let selfSize = CGSize(width: selfWidth, height: selfHeight)
        let selfOrigin = CGPoint(x: selfX, y: selfY)
        frameHolder?.frame = CGRect(origin: selfOrigin, size: selfSize)
        return totalHeight(ifSelfHeight: selfHeight)
    }
    
    public func size(ifWidth width: CGFloat) -> CGSize {
        let horizontalBounds = CGRect(origin: .zero, size: CGSize(width: width, height: 0))
        let (_, selfWidth) = horizontalLayout(rule: h, inBounds: horizontalBounds)
        let subTotalHeight = sub.size(ifWidth: selfWidth).height
        let selfHeight = subTotalHeight
        return CGSize(width: selfWidth, height: totalHeight(ifSelfHeight: selfHeight))
    }
    
    func totalHeight(ifSelfHeight height: CGFloat) -> CGFloat {
        return height + top + bottom
    }
}
