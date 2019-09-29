//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core


final class MainViewController: MUSViewController<MainView> {
    typealias AdaptiveAudioPlayerViewRun = (AdaptiveAudioPlayerViewType) -> Driver<Void>
    let adaptiveAudioPlayerViewRun: AdaptiveAudioPlayerViewRun
    
    init(adaptiveAudioPlayerViewRun: @escaping AdaptiveAudioPlayerViewRun) {
        self.adaptiveAudioPlayerViewRun = adaptiveAudioPlayerViewRun
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeView() -> MainView {
        return MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v.audioPlayerView.bind(adaptiveAudioPlayerViewRun)
        bottomSheetController.delegate = self
    }
    
    override var hidesNavigationBar: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        bottomSheetController.prepare()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        bottomSheetController.bottomSheetMinHeight = bottomSheetMinHeight()
    }
    
    func set(contentController: UIViewController) {
        loadViewIfNeeded()
        contentController.additionalSafeAreaInsets.bottom += k.bottomSheetMinHeight
        embed(child: contentController) { contentView in
            v.set(contentView: contentView)
        }
    }
    
    private lazy var bottomSheetController = BottomSheetController(
        bottomSheet: v.bottomSheet,
        container: view,
        bottomSheetMaxHeight: UIScreen.main.bounds.height * 0.85,
        bottomSheetMinHeight: bottomSheetMinHeight()
    )
    
    private func bottomSheetMinHeight() -> CGFloat {
        return k.bottomSheetMinHeight + view.safeAreaInsets.bottom
    }
}

// MARK: - BottomSheetControllerDelegate

extension MainViewController: BottomSheetControllerDelegate {
    func bottomSheetControllerAnimatingState(to state: BottomSheetController.State) {
        switch state {
        case .closed: v.audioPlayerView.state = .minimized
        case .open: v.audioPlayerView.state = .maximized
        }
    }
    
    func bottomSheetControllerAnimatingFirstKeyframeState(to state: BottomSheetController.State) {
        switch state {
        case .closed: v.audioPlayerView.prepareForFirstKeyFrameMinimization()
        case .open: v.audioPlayerView.prepareForFirstKeyFrameMaximization()
        }
    }
    
    func bottomSheetControllerAnimatingLastKeyframeState(to state: BottomSheetController.State) {
        switch state {
        case .closed: v.audioPlayerView.prepareForLastKeyFrameMinimization()
        case .open: v.audioPlayerView.prepareForLastKeyFrameMaximization()
        }
    }
}

// MARK: - MainView

final class MainView: UIView {
    private(set) lazy var bottomSheet: UIView = {
        let view = GradientView(topToBottom: stylesheet().color.metalicGradient)
        stylesheet().cornerRadius.large(view)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private(set) lazy var audioPlayerView = AdaptiveAudioPlayerView(frame: frame)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        bottomSheet.addSubview(audioPlayerView)
        AutoLayout.pin(audioPlayerView, to: bottomSheet)
        stylesheet().view.background(self)
    }
    
    // MARK: Public
    
    func set(contentView: UIView) {
        addSubview(contentView)
        AutoLayout.pin(contentView, to: self)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

private enum k {
    static let bottomSheetMinHeight = CGFloat(100)
}
