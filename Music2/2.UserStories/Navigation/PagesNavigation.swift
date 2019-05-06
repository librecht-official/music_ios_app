//
//  PagesNavigation.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

protocol PagesNavigator {
    func navigate(to route: PagesNavigation.Route)
}

protocol PagesNavigatable: AnyObject {
    var navigator: PagesNavigator { get set }
}

final class PagesNavigation: PagesNavigator {
    enum Route {
        case explore
    }
    
    let controller: NavigationController
    
    init(root: UIViewController & PagesNavigatable) {
        self.controller = NavigationController(rootViewController: root)
        root.navigator = self
    }
    
    func navigate(to route: PagesNavigation.Route) {
        
    }
}
