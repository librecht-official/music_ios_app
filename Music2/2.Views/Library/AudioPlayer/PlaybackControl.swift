//
//  PlaybackControl.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YogaKit

class PlaybackControl: LayoutComponent {
    private(set) lazy var playButton = UIButton(type: .system)
    private(set) lazy var fastForwardButton = UIButton(type: .system)
    private(set) lazy var fastBackwardButton = UIButton(type: .system)
    
    func render() -> LayoutNode {
        configureViews()
        
        return Layout.Composite(UIView(), style: Styles.container, [
            Layout.Button(fastBackwardButton, style: Styles.button),
            Layout.Button(playButton, style: Styles.button),
            Layout.Button(fastForwardButton, style: Styles.button),
        ])
    }
    
    func configureViews() {
        playButton.tintColor = Color.black.uiColor
        playButton.setImage(Asset.play44x44.image, for: .normal)
        playButton.setImage(Asset.pause44x44.image, for: .selected)
        
        fastForwardButton.tintColor = Color.black.uiColor
        fastForwardButton.setImage(Asset.fastForward44x44.image, for: .normal)
        
        fastBackwardButton.tintColor = Color.black.uiColor
        fastBackwardButton.setImage(Asset.fastBackward44x44.image, for: .normal)
    }
}

private extension Styles {
    static let container = Layout.Style<UIView>(layout: {
        $0.flexGrow = 1
        $0.flexDirection = .row
        $0.justifyContent = .spaceBetween
        $0.alignItems = .stretch
    })
    
    static let button = Layout.Style<UIButton>(layout: {
        $0.flexGrow = 1
        $0.marginHorizontal = 4
    })
}

extension PlaybackControl: ReactiveCompatible {
}

extension Reactive where Base: PlaybackControl {
    var isEnabled: Binder<Bool> {
        return Binder(self.base) { (view, value) in
            view.playButton.isEnabled = value
            view.fastForwardButton.isEnabled = value
            view.fastBackwardButton.isEnabled = value
        }
    }
}
