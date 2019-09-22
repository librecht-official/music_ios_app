//
//  HeightAwareColumn.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

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
            case let .fixed(height, sub):
                return FlexibleColumnItem.fixed(
                    height: height, { sub.performLayout(inFrame: $0) }
                )
            case let .automatic(sub):
                return FlexibleColumnItem.automatic(
                    sub, { _ = sub.performLayout(inOrigin: $0.origin, width: $0.width) }
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

