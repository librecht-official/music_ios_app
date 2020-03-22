//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import CoreGraphics


public extension CGRect {
    /// Linear interpolation between two frames, where 0 <= progress <= 1
    func interpolate(toFrame: CGRect, progress p: CGFloat) -> CGRect {
        let x = toFrame.origin.x * p + self.origin.x * (1 - p)
        let y = toFrame.origin.y * p + self.origin.y * (1 - p)
        let w = toFrame.size.width * p + self.size.width * (1 - p)
        let h = toFrame.size.height * p + self.size.height * (1 - p)
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    /// Returns Rect with zero origin
    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}
