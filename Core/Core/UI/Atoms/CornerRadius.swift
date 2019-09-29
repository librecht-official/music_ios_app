//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


public enum CornerRadius {
    case abs(CGFloat)
    case multiplyHeight(CGFloat)
    case multiplyWidth(CGFloat)
    
    func value(forSize size: CGSize) -> CGFloat {
        switch self {
        case let .abs(val):
            return val
        case let .multiplyHeight(m):
            return size.height * m
        case let .multiplyWidth(m):
            return size.width * m
        }
    }
}


public extension UIView {
    func roundCorners(_ cornerRadius: CornerRadius) {
        layer.cornerRadius = cornerRadius.value(forSize: bounds.size)
    }
}
