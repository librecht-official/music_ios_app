//
//  MainViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    struct Style {
        let bottomSheetMinHeight = CGFloat(100)
    }
    var style = Style()
    
    private lazy var pagesViewController = PagesViewController()
    
    private lazy var audioPlayerController = AudioPlayerViewController()
    private lazy var bottomSheetController = BottomSheetController(
        bottomSheet: bottomSheet,
        container: view,
        bottomSheetMaxHeight: min(UIScreen.main.bounds.height * 0.85, 600),
        bottomSheetMinHeight: style.bottomSheetMinHeight + view.safeAreaInsets.bottom
    )
    private lazy var bottomSheet: UIView = {
        let view = GradientView(top: Color.altoGray.uiColor, bottom: Color.lightGray.uiColor)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white.uiColor
        
        bottomSheetController.delegate = self
        
//        pagesViewController.additionalSafeAreaInsets.bottom += style.bottomSheetMinHeight
        let nc = UINavigationController(rootViewController: PagesViewController())
        nc.additionalSafeAreaInsets.bottom += style.bottomSheetMinHeight
        nc.setNavigationBarHidden(true, animated: false)
        embed(child: nc)
        view.constrain(
            subview: nc.view//,
//            topAnchor: view.safeAreaLayoutGuide.topAnchor
        )
        
        embed(child: audioPlayerController, inside: bottomSheet)
        bottomSheet.constrain(subview: audioPlayerController.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        bottomSheetController.prepare()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        bottomSheetController.bottomSheetMinHeight = style.bottomSheetMinHeight + view.safeAreaInsets.bottom
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
