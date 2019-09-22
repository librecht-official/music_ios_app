//
//  Length.swift
//  Layout
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public enum Length {
    /// Absolute value in points
    case abs(CGFloat)
    /// Value relative to superview
    case rel(CGFloat)
    
    func width(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return val
        case let .rel(proportion): return bounds.width * proportion
        }
    }
    
    func height(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return val
        case let .rel(proportion): return bounds.height * proportion
        }
    }
}
