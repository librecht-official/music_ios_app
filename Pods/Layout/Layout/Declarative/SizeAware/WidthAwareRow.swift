//
//  WidthAwareRow.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

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
            case let .fixed(width, sub):
                return FlexibleRowItem.fixed(
                    width: width, { sub.performLayout(inFrame: $0) }
                )
            case let .automatic(sub):
                return FlexibleRowItem.automatic(
                    sub, { _ = sub.performLayout(inOrigin: $0.origin, height: $0.height) }
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
