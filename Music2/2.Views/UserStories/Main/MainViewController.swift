//
//  MainViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private lazy var bottomSheet: UIView = {
        let view = GradientView(top: Color.altoGray.uiColor, bottom: Color.lightGray.uiColor)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var audioPlayerController = AudioPlayerViewController()
    
    private lazy var bottomSheetController = BottomSheetController(
        bottomSheet: bottomSheet,
        container: view,
        bottomSheetMaxHeight: UIScreen.main.bounds.height * 0.85,
        bottomSheetMinHeight: 100
    )
    
    private lazy var albumsListController = NavigationController(rootViewController: AlbumsListViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetController.delegate = self
        
        albumsListController.additionalSafeAreaInsets.bottom += 100
        embed(child: albumsListController)
        view.constrain(subview: albumsListController.view)
        
        embed(child: audioPlayerController, inside: bottomSheet)
        bottomSheet.constrain(subview: audioPlayerController.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        bottomSheetController.prepare()
    }
}

extension MainViewController: BottomSheetControllerDelegate {
    func bottomSheetControllerAnimatingState(to state: BottomSheetController.State) {
        switch state {
        case .closed:
            audioPlayerController.minimize()
        case .open:
            audioPlayerController.maximize()
        }
    }
    
    func bottomSheetControllerAnimatingFirstKeyframeState(to state: BottomSheetController.State) {
        switch state {
        case .closed:
            audioPlayerController.prepareForFirstKeyFrameMinimization()
        case .open:
            audioPlayerController.prepareForFirstKeyFrameMaximization()
        }
    }
    
    func bottomSheetControllerAnimatingLastKeyframeState(to state: BottomSheetController.State) {
        switch state {
        case .closed:
            audioPlayerController.prepareForLastKeyFrameMinimization()
        case .open:
            audioPlayerController.prepareForLastKeyFrameMaximization()
        }
    }
}
