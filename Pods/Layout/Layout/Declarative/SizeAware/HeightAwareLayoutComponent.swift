//
//  HeightAwareLayoutComponent.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public protocol HeightAwareLayoutComponent: HeightAware {
    /// Returns calculated total height occupied by self plus insets
    func performLayout(inOrigin origin: CGPoint, width: CGFloat) -> CGFloat
}
