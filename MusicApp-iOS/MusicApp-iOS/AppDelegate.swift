//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Core


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Core.load(stylesheet: AppStylesheet())
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        stylesheet().view.background(window)
        stylesheet().view.primaryTinted(window)
        let coordinator = AppCoordinator(window: window)
        
        coordinator.start()
        window.makeKeyAndVisible()
        
        self.window = window
        self.coordinator = coordinator
        
        return true
    }
}
