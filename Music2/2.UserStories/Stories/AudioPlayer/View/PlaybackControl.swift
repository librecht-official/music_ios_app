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

final class PlaybackControl: UIView {
    struct Style {
        let playButton = IconButtonStyle(
            normalIcon: Asset.play44x44, selectedIcon: Asset.pause44x44,
            tintColor: Color.black
        )
        let fastForwardButton = IconButtonStyle(
            normalIcon: Asset.fastForward44x44, tintColor: Color.black
        )
        let fastBackwardButton = IconButtonStyle(
            normalIcon: Asset.fastBackward44x44, tintColor: Color.black
        )
    }
    var style = Style() { didSet { apply(style: style) } }
    func apply(style: Style) {
        playButton.apply(style: style.playButton)
        fastForwardButton.apply(style: style.fastForwardButton)
        fastBackwardButton.apply(style: style.fastBackwardButton)
    }
    
    private(set) lazy var playButton = UIButton(type: .custom)
    private(set) lazy var fastForwardButton = UIButton(type: .system)
    private(set) lazy var fastBackwardButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(fastBackwardButton)
        addSubview(playButton)
        addSubview(fastForwardButton)
        apply(style: style)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackRow(
            alignment: .fill, spacing: 4, [
                StackItem({ self.fastBackwardButton.frame = $0 }, length: .weight(1)),
                StackItem({ self.playButton.frame = $0 }, length: .weight(1)),
                StackItem({ self.fastForwardButton.frame = $0 }, length: .weight(1)),
            ],
            inFrame: bounds
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
