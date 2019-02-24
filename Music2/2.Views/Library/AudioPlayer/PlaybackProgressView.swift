//
//  PlaybackProgressView.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlaybackProgressView: MView {
    // TODO: Make custom control, since this solution is buggy
    private(set) lazy var slider = UISlider()
    private(set) lazy var currentTimeLabel = UILabel()
    private(set) lazy var totalTimeLabel = UILabel()
    
    override func prepareLayout() {
        let time = UIStackView(arrangedSubviews: [currentTimeLabel, totalTimeLabel])
        time.distribution = .fillEqually
        
        stackVertically(spacing: 4, [
            VStackItem(slider),
            VStackItem(time, [.leadingInset(20), .trailingInset(20)])
        ])
        sendSubviewToBack(time)
    }
    
    override func configureViews() {
        currentTimeLabel.text = Format.undefinedDuration
        currentTimeLabel.textAlignment = .left
        currentTimeLabel.textColor = Color.lightGray.uiColor
        totalTimeLabel.text = Format.undefinedDuration
        totalTimeLabel.textAlignment = .right
        totalTimeLabel.textColor = Color.lightGray.uiColor
        slider.setThumbImage(Asset.progressThumb.image, for: .normal)
        slider.setMinimumTrackImage(Asset.playedProgress.image, for: .normal)
        slider.setMaximumTrackImage(Asset.remainingProgress.image, for: .normal)
    }
}

struct PlaybackProgressViewModel {
    let currentTime: TimeInterval?
    let totalTime: TimeInterval?
}

extension Reactive where Base: PlaybackProgressView {
    var playbackInfo: AnyObserver<PlaybackProgressViewModel> {
        return AnyObserver { event in
            if case let .next(viewModel) = event,
                let current = viewModel.currentTime,
                let total = viewModel.totalTime {
                
                self.base.currentTimeLabel.text = Format.trackDuration(current)
                self.base.totalTimeLabel.text = Format.trackDuration(total)
                
                self.base.slider.isEnabled = total != 0.0
                if total != 0.0 {
                    self.base.slider.value = Float(current / total)
                }
            }
        }
    }
}
