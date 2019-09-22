//
//  Component+SizeAware.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

extension Component: WidthAware where View: WidthAware {
    public func size(ifHeight height: CGFloat) -> CGSize {
        return view.size(ifHeight: height)
    }
}

extension Component: HeightAware where View: HeightAware {
    public func size(ifWidth width: CGFloat) -> CGSize {
        return view.size(ifWidth: width)
    }
}
