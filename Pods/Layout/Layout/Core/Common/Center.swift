//
//  Center.swift
//  Layout
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public enum Center {
    /// absolute value in points
    case abs(CGFloat)
    /// value relative to superview
    case rel(CGFloat)
    
    func x(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return bounds.midX + val
        case let .rel(proportion): return bounds.midX * proportion
        }
    }
    
    func y(for bounds: CGRect) -> CGFloat {
        switch self {
        case let .abs(val): return bounds.midY + val
        case let .rel(proportion): return bounds.midY * proportion
        }
    }
}
