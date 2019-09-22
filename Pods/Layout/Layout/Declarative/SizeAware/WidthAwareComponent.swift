//
//  WidthAwareComponent.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Wrapper-component for WidthAware
public struct WidthAwareComponent: WidthAwareLayoutComponent {
    public typealias Holder = FrameHolder & WidthAware
    public let frameHolder: Holder
    public let v: VerticalLayoutRule
    public let leading, trailing: CGFloat
    
    public init(
        _ frameHolder: Holder,
        v: VerticalLayoutRule = .v1(top: 0, bottom: 0),
        leading: CGFloat = 0, trailing: CGFloat = 0) {
        
        self.frameHolder = frameHolder
        self.v = v
        self.leading = leading
        self.trailing = trailing
    }
    
    public func performLayout(inOrigin origin: CGPoint, height: CGFloat) -> CGFloat {
        // selfWidth is the width that frameHolder require.
        // totalWidth is selfWidth + top + bottom
        let verticalBounds = CGRect(origin: .zero, size: CGSize(width: 0, height: height))
        let (y1, selfHeight) = verticalLayout(rule: v, inBounds: verticalBounds)
        let selfY = origin.y + y1
        let x = origin.x + leading
        let selfWidth = frameHolder.size(ifHeight: selfHeight).width
        let selfOrigin = CGPoint(x: x, y: selfY)
        let selfSize = CGSize(width: selfWidth, height: selfHeight)
        frameHolder.frame = CGRect(origin: selfOrigin, size: selfSize)
        return totalWidth(ifSelfWidth: selfWidth)
    }
    
    public func size(ifHeight height: CGFloat) -> CGSize {
        let verticalBounds = CGRect(origin: .zero, size: CGSize(width: 0, height: height))
        let (_, selfHeight) = verticalLayout(rule: v, inBounds: verticalBounds)
        var size = frameHolder.size(ifHeight: selfHeight)
        size.width = totalWidth(ifSelfWidth: size.width)
        return size
    }
    
    func totalWidth(ifSelfWidth width: CGFloat) -> CGFloat {
        return width + leading + trailing
    }
}
