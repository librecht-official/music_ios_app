//
//  Insets.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public struct Insets {
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat
    
    public init(
        top: CGFloat = 0, bottom: CGFloat = 0,
        leading: CGFloat = 0, trailing: CGFloat = 0) {
        
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
    
    public init(each a: CGFloat) {
        self.init(top: a, bottom: a, leading: a, trailing: a)
    }
    
    public static let zero = Insets()
    
    var topPlusBottom: CGFloat {
        return top + bottom
    }
    
    var leadingPlusTrailing: CGFloat {
        return leading + trailing
    }
}
