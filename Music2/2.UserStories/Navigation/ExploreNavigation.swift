//
//  ExploreNavigation.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxCocoa

protocol ExploreNavigator {
    func navigate(to route: ExploreNavigation.Route) -> Signal<Void>
}

protocol ExploreNavigatable: AnyObject {
    var navigator: ExploreNavigator! { get set }
}

final class ExploreNavigation: ExploreNavigator {
    enum Route {
        case album(Album)
    }
    
    let controller: UINavigationController
    
    init(controller: UINavigationController) {
        self.controller = controller
    }
    
    func navigate(to route: ExploreNavigation.Route) -> Signal<Void> {
        switch route {
        case let .album(album):
            let vc = AlbumTracksViewController(album: album)
            return controller.push(vc, animated: true)
        }
    }
}
