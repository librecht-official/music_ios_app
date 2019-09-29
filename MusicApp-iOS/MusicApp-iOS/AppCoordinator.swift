//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import MainKit


final class AppCoordinator {
    let window: UIWindow
    let env: AppEnvironment
    
    init(window: UIWindow) {
        self.window = window
        self.env = AppEnvironment()
    }
    
    func start() {
        let nc = UINavigationController()
        nc.isNavigationBarHidden = true
        let main = MainCoordinator(environment: env, navigator: nc)

        window.rootViewController = nc
        main.start()
    }
}
