//
//  SizeAware.swift
//  Layout
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Something that is able to calculate it's height for given width
public protocol HeightAware {
    func size(ifWidth width: CGFloat) -> CGSize
}

/// Something that is able to calculate it's width for given height
public protocol WidthAware {
    func size(ifHeight height: CGFloat) -> CGSize
}

/// Something that is able to calculate it's size for given restricting width and height
public protocol SizeAware: HeightAware, WidthAware {
    func sizeThatFits(_ size: CGSize) -> CGSize
}

public extension SizeAware {
    func size(ifWidth width: CGFloat) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func size(ifHeight height: CGFloat) -> CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height))
    }
}
