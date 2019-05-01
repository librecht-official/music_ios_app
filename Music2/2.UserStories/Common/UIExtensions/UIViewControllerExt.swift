//
//  UIViewControllerExt.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

extension UIViewController {
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
