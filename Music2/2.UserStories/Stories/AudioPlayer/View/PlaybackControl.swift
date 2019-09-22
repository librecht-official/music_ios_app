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
import Layout

final class PlaybackControl: UIView {
    // MARK: Style
    
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
    
    // MARK: Properties
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private lazy var layout = Row(spacing: 4, [
        RowItem.fixed(width: .weight(1), Component(fastBackwardButton)),
        RowItem.fixed(width: .weight(1), Component(playButton)),
        RowItem.fixed(width: .weight(1), Component(fastForwardButton))
    ])
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.performLayout(inFrame: bounds)
    }
}

// MARK: - Rx

extension Reactive where Base: PlaybackControl {
    var isEnabled: Binder<Bool> {
        return Binder(self.base) { (view, value) in
            view.playButton.isEnabled = value
            view.fastForwardButton.isEnabled = value
            view.fastBackwardButton.isEnabled = value
        }
    }
}
