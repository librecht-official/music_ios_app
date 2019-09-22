//
//  Column.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - Column
/// Vertical fixed-size stack
public struct Column: LayoutComponent {
    public let spacing: CGFloat
    public let distribution: StackDistribution
    public let items: [ColumnItem]
    
    public init(
        spacing: CGFloat,
        distribution: StackDistribution = .evenlySpaced,
        _ items: [ColumnItem]) {
        
        self.spacing = spacing
        self.distribution = distribution
        self.items = items
    }
    
    public func performLayout(inFrame frame: CGRect) {
        stackColumn(
            spacing: spacing, distribution: distribution, items.map { item -> StackItem in
                return StackItem(
                    { item.sub.performLayout(inFrame: $0) },
                    length: item.height(ifStackWidth: frame.width),
                    top: item.insets.top, bottom: item.insets.bottom,
                    leading: item.insets.leading, trailing: item.insets.trailing
                )
            },
            inFrame: frame
        )
    }
}
