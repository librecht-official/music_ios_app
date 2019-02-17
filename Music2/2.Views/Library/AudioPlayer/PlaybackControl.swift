//
//  PlaybackControl.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

class PlaybackControl: MView {
    private(set) lazy var stack = UIStackView()
    private(set) lazy var playButton = UIButton(type: .system)
    private(set) lazy var fastForwardButton = UIButton(type: .system)
    private(set) lazy var fastBackwardButton = UIButton(type: .system)
    
    override func prepareLayout() {
        [stack, playButton, fastForwardButton, fastBackwardButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        constrain(subview: stack, insets: UIEdgeInsets.standard8)
        stack.addArrangedSubview(fastBackwardButton)
        stack.addArrangedSubview(playButton)
        stack.addArrangedSubview(fastForwardButton)
        
        stack.spacing = 8
        stack.distribution = .fillEqually
    }
    
    override func configureViews() {
        playButton.tintColor = Color.black.uiColor
        playButton.setImage(Asset.play44x44.image, for: .normal)
        playButton.setImage(Asset.pause44x44.image, for: .selected)
        
        fastForwardButton.tintColor = Color.black.uiColor
        fastForwardButton.setImage(Asset.fastForward44x44.image, for: .normal)
        
        fastBackwardButton.tintColor = Color.black.uiColor
        fastBackwardButton.setImage(Asset.fastBackward44x44.image, for: .normal)
    }
}
