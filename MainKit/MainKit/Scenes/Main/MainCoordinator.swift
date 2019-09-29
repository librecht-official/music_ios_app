//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Core


public final class MainCoordinator {
    public typealias Env = Explore.Env
    let env: Env
    let navigator: UINavigationController
    
    public init(environment: Env, navigator: UINavigationController) {
        self.env = environment
        self.navigator = navigator
    }
    
    public func start() {        
        let mainVC = MainViewController(adaptiveAudioPlayerViewRun: AudioPlayerUI.run § env)
        let tabsVC = TabsViewController()
        tabsVC.set(tabItems: [
            TabItem(
                tab: .title(L10n.Main.Tab.explore),
                controller: ExploreViewController(bind: Explore.run § env)
            ),
            TabItem(tab: .title(L10n.Main.Tab.playlists), controller: UIViewController()),
            TabItem(tab: .title(L10n.Main.Tab.favorites), controller: UIViewController()),
            TabItem(tab: .icon(stylesheet().image.profileStub), controller: UIViewController()),
        ])
        let nc = UINavigationController(rootViewController: tabsVC)
        nc.isNavigationBarHidden = true
        mainVC.set(contentController: nc)
        
        navigator.viewControllers = [mainVC]
    }
}
