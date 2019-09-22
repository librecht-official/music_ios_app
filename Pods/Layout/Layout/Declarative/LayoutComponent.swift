//
//  LayoutComponent.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public protocol LayoutComponent {
    func performLayout(inFrame frame: CGRect)
}
