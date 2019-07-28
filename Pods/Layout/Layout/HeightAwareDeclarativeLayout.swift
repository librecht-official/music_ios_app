//
//  HeightAwareDeclarativeLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 14/07/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public protocol HeightAwareLayoutComponent: HeightAware {
    /// Returns calculated total height occupied by self plus insets
    func performLayout(inOrigin origin: CGPoint, width: CGFloat) -> CGFloat
}

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

/// Wrapper-component for Container of HeightAware
public struct HeightAwareContainer: HeightAwareLayoutComponent {
    public let frameHolder: FrameHolder?
    public let inner: HeightAwareLayoutComponent
    public let h: HorizontalLayoutRule
    public let top, bottom: CGFloat
    public let relative: Bool
    
    public init(
        _ frameHolder: FrameHolder?,
        h: HorizontalLayoutRule, top: CGFloat, bottom: CGFloat,
        relative: Bool = true, inner: HeightAwareLayoutComponent) {
        
        self.frameHolder = frameHolder
        self.inner = inner
        self.h = h
        self.top = top
        self.bottom = bottom
        self.relative = relative
    }
    
    public func performLayout(inOrigin origin: CGPoint, width: CGFloat) -> CGFloat {
        // selfHeight is inner's height
        let horizontalBounds = CGRect(origin: origin, size: CGSize(width: width, height: 0))
        let (x1, selfWidth) = horizontalLayout(rule: h, inBounds: horizontalBounds)
        let selfX = origin.x + x1
        let selfY = origin.y + top
        let innerOrigin = relative ? CGPoint(x: 0, y: 0) : CGPoint(x: selfX, y: selfY) 
        let innerTotalHeight = inner.performLayout(inOrigin: innerOrigin, width: selfWidth)
        let selfHeight = innerTotalHeight
        let selfSize = CGSize(width: selfWidth, height: selfHeight)
        let selfOrigin = CGPoint(x: selfX, y: selfY)
        frameHolder?.frame = CGRect(origin: selfOrigin, size: selfSize)
        return totalHeight(ifSelfHeight: selfHeight)
    }
    
    public func size(ifWidth width: CGFloat) -> CGSize {
        let horizontalBounds = CGRect(origin: .zero, size: CGSize(width: width, height: 0))
        let (_, selfWidth) = horizontalLayout(rule: h, inBounds: horizontalBounds)
        let innerTotalHeight = inner.size(ifWidth: selfWidth).height
        let selfHeight = innerTotalHeight
        return CGSize(width: selfWidth, height: totalHeight(ifSelfHeight: selfHeight))
    }
    
    func totalHeight(ifSelfHeight height: CGFloat) -> CGFloat {
        return height + top + bottom
    }
}

public enum HeightAwareColumnItem {
    case fixed(height: CGFloat, LayoutComponent)
    case automatic(HeightAwareLayoutComponent)
}

/// Vertical free-size stack
public struct HeightAwareColumn: HeightAwareLayoutComponent {
    public let spacing: CGFloat, items: [HeightAwareColumnItem]
    let columnItems: [FlexibleColumnItem]
    
    public init(spacing: CGFloat, _ items: [HeightAwareColumnItem]) {
        self.spacing = spacing
        self.items = items
        self.columnItems = items.map { item -> FlexibleColumnItem in
            switch item {
            case let .fixed(height, inner):
                return FlexibleColumnItem.fixed(
                    height: height, { inner.performLayout(inFrame: $0) }
                )
            case let .automatic(inner):
                return FlexibleColumnItem.automatic(
                    inner, { _ = inner.performLayout(inOrigin: $0.origin, width: $0.width) }
                )
            }
        }
    }
    
    public func performLayout(inOrigin origin: CGPoint, width: CGFloat) -> CGFloat {
        return stackHeightAwareColumn(
            spacing: spacing, columnItems, inOrigin: origin, width: width
        )
    }
    
    public func size(ifWidth width: CGFloat) -> CGSize {
        let h = stackHeightAwareColumn(
            spacing: spacing, columnItems, inOrigin: .zero, width: width
        )
        return CGSize(width: width, height: h)
    }
}
