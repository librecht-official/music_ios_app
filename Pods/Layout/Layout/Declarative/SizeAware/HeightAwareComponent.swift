//
//  HeightAwareComponent.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Wrapper-component for HeightAware
public struct HeightAwareComponent: HeightAwareLayoutComponent {
    public typealias Holder = FrameHolder & HeightAware
    public let frameHolder: Holder
    public let h: HorizontalLayoutRule
    public let top, bottom: CGFloat
    
    public init(
        _ frameHolder: Holder,
        h: HorizontalLayoutRule = .h1(leading: 0, trailing: 0),
        top: CGFloat = 0, bottom: CGFloat = 0) {
        
        self.frameHolder = frameHolder
        self.h = h
        self.top = top
        self.bottom = bottom
    }
    
    public func performLayout(inOrigin origin: CGPoint, width: CGFloat) -> CGFloat {
        // selfHeight is the height that frameHolder require.
        // totalHeight is selfHeight + top + bottom
        let horizontalBounds = CGRect(origin: .zero, size: CGSize(width: width, height: 0))
        let (x1, selfWidth) = horizontalLayout(rule: h, inBounds: horizontalBounds)
        let selfX = origin.x + x1
        let y = origin.y + top
        let selfHeight = frameHolder.size(ifWidth: selfWidth).height
        let selfOrigin = CGPoint(x: selfX, y: y)
        let selfSize = CGSize(width: selfWidth, height: selfHeight)
        frameHolder.frame = CGRect(origin: selfOrigin, size: selfSize)
        return totalHeight(ifSelfHeight: selfHeight)
    }
    
    public func size(ifWidth width: CGFloat) -> CGSize {
        let horizontalBounds = CGRect(origin: .zero, size: CGSize(width: width, height: 0))
        let (_, selfWidth) = horizontalLayout(rule: h, inBounds: horizontalBounds)
        var size = frameHolder.size(ifWidth: selfWidth)
        size.height = totalHeight(ifSelfHeight: size.height)
        return size
    }
    
    func totalHeight(ifSelfHeight height: CGFloat) -> CGFloat {
        return height + top + bottom
    }
}
