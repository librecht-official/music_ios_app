//
//  GestureRecognizerExt.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

extension UIGestureRecognizer.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .began: return "began"
        case .cancelled: return "cancelled"
        case .changed: return "changed"
        case .ended: return "ended"
        case .failed: return "failed"
        case .possible: return "possible"
        }
    }
}
