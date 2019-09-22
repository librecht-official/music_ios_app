//
//  EmptyComponent.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - EmptyComponent
/// Convenience empty leaf node of the layout tree.
///
/// Usefull to describe empty (placeholder) spaces inside stack layout.
public struct EmptyComponent: LayoutComponent {
    public init() {
    }
    
    public func performLayout(inFrame frame: CGRect) {
    }
}
