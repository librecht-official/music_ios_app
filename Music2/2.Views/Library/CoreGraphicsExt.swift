//
//  CoreGraphicsExt.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    /**
     Linear interpolation between two frames, where 0 <= p <= 1
     */
    func interpolate(toFrame: CGRect, p: CGFloat) -> CGRect {
        let x = toFrame.origin.x * p + self.origin.x * (1 - p)
        let y = toFrame.origin.y * p + self.origin.y * (1 - p)
        let w = toFrame.size.width * p + self.size.width * (1 - p)
        let h = toFrame.size.height * p + self.size.height * (1 - p)
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
