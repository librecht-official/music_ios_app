//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


public extension UIViewController {
    func embed(child: UIViewController, inside container: UIView? = nil) {
        addChild(child)
        (container ?? view).addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func embed(child: UIViewController, addSubview: (UIView) -> ()) {
        addChild(child)
        addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(child: UIViewController, removeSubview: (UIView) -> ()) {
        child.willMove(toParent: nil)
        removeSubview(child.view)
        child.removeFromParent()
    }
}
