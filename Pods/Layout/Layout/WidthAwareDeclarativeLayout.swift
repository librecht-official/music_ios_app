//
//  WidthAwareDeclarativeLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 15/07/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public protocol WidthAwareLayoutComponent: WidthAware {
    /// Returns calculated total width occupied by self plus insets
    func performLayout(inOrigin origin: CGPoint, height: CGFloat) -> CGFloat
}

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

/// Wrapper-component for Container of WidthAware
public struct WidthAwareContainer: WidthAwareLayoutComponent {
    public let frameHolder: FrameHolder?
    public let inner: WidthAwareLayoutComponent
    public let v: VerticalLayoutRule
    public let leading, trailing: CGFloat
    public let relative: Bool
    
    public init(
        _ frameHolder: FrameHolder?,
        v: VerticalLayoutRule, leading: CGFloat, trailing: CGFloat,
        relative: Bool = true, inner: WidthAwareLayoutComponent) {
        
        self.frameHolder = frameHolder
        self.inner = inner
        self.v = v
        self.leading = leading
        self.trailing = trailing
        self.relative = relative
    }
    
    public func performLayout(inOrigin origin: CGPoint, height: CGFloat) -> CGFloat {
        // selfWidth is inner's total width
        let verticalBounds = CGRect(origin: .zero, size: CGSize(width: 0, height: height))
        let (y1, selfHeight) = verticalLayout(rule: v, inBounds: verticalBounds)
        let selfY = origin.y + y1
        let selfX = origin.x + leading
        let innerOrigin = relative ? CGPoint(x: 0, y: 0) : CGPoint(x: selfX, y: selfY) 
        let innerTotalWidth = inner.performLayout(inOrigin: innerOrigin, height: selfHeight)
        let selfWidth = innerTotalWidth
        let selfSize = CGSize(width: selfWidth, height: selfHeight)
        let selfOrigin = CGPoint(x: selfX, y: selfY)
        frameHolder?.frame = CGRect(origin: selfOrigin, size: selfSize)
        return totalWidth(ifSelfWidth: selfWidth)
    }
    
    public func size(ifHeight height: CGFloat) -> CGSize {
        let verticalBounds = CGRect(origin: .zero, size: CGSize(width: 0, height: height))
        let (_, selfHeight) = verticalLayout(rule: v, inBounds: verticalBounds)
        let innerTotalWidth = inner.size(ifHeight: selfHeight).width
        let selfWidth = innerTotalWidth
        return CGSize(width: totalWidth(ifSelfWidth: selfWidth), height: selfHeight)
    }
    
    func totalWidth(ifSelfWidth width: CGFloat) -> CGFloat {
        return width + leading + trailing
    }
}

public enum WidthAwareRowItem {
    case fixed(width: CGFloat, LayoutComponent)
    case automatic(WidthAwareLayoutComponent)
}

/// Horizontal free-size stack
public struct WidthAwareRow: WidthAwareLayoutComponent {
    public let spacing: CGFloat, items: [WidthAwareRowItem]
    let rowItems: [FlexibleRowItem]
    
    public init(spacing: CGFloat, _ items: [WidthAwareRowItem]) {
        self.spacing = spacing
        self.items = items
        self.rowItems = items.map { item -> FlexibleRowItem in
            switch item {
            case let .fixed(width, inner):
                return FlexibleRowItem.fixed(
                    width: width, { inner.performLayout(inFrame: $0) }
                )
            case let .automatic(inner):
                return FlexibleRowItem.automatic(
                    inner, { _ = inner.performLayout(inOrigin: $0.origin, height: $0.height) }
                )
            }
        }
    }
    
    public func performLayout(inOrigin origin: CGPoint, height: CGFloat) -> CGFloat {
        return stackWidthAwareRow(spacing: spacing, rowItems, inOrigin: origin, height: height)
    }
    
    public func size(ifHeight height: CGFloat) -> CGSize {
        let w = totalWidthAwareRowWidth(spacing: spacing, rowItems, height: height)
        return CGSize(width: w, height: height)
    }
}
