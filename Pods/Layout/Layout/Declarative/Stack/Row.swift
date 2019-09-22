//
//  Row.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - Row
/// Horizontal fixed-size stack
public struct Row: LayoutComponent {
    public let spacing: CGFloat
    public let distribution: StackDistribution
    public let items: [RowItem]
    
    public init(
        spacing: CGFloat = 0,
        distribution: StackDistribution = .evenlySpaced,
        _ items: [RowItem]) {
        
        self.spacing = spacing
        self.distribution = distribution
        self.items = items
    }
    
    public func performLayout(inFrame frame: CGRect) {
        stackRow(
            spacing: spacing, distribution: distribution, items.map { item -> StackItem in
                return StackItem(
                    { item.sub.performLayout(inFrame: $0) },
                    length: item.width(ifStackHeight: frame.height),
                    top: item.insets.top, bottom: item.insets.bottom,
                    leading: item.insets.leading, trailing: item.insets.trailing
                )
            },
            inFrame: frame
        )
    }
}
