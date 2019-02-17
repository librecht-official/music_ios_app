//
//  NavigationController.swift
//  Music2
//
//  Created by Vladislav Librecht on 16.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        navigationBar.isTranslucent = true
        navigationBar.tintColor = Color.white.uiColor
        navigationBar.barTintColor = Color.white.uiColor
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.white.uiColor
        ]
    }
}

protocol NavigationBarCustomization {
    var navigationBarShouldBeHidden: Bool { get }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool) {
        
        viewController.additionalSafeAreaInsets = additionalSafeAreaInsets
        
        if let custom = viewController as? NavigationBarCustomization, custom.navigationBarShouldBeHidden {
            setNavigationBarHidden(true, animated: animated)
        }
        else {
            setNavigationBarHidden(false, animated: animated)
        }
    }
}
