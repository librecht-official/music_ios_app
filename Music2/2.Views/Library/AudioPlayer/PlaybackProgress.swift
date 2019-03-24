//
//  PlaybackProgress.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YogaKit

final class PlaybackProgress: LayoutComponent {
    private(set) lazy var progressSlider = ProgressSlider()
    private(set) lazy var currentTimeLabel = UILabel()
    private(set) lazy var totalTimeLabel = UILabel()
    
    func render() -> LayoutNode {
        currentTimeLabel.text = Format.undefinedDuration
        totalTimeLabel.text = Format.undefinedDuration
        
        return Layout.Composite(UIView(), style: Styles.container, [
            Layout.Component(progressSlider),
            Layout.Composite(UIView(), style: Styles.timeContainer, [
                Layout.Label(currentTimeLabel, style: Styles.currentTime),
                Layout.Label(totalTimeLabel, style: Styles.totalTime)
            ])
        ])
    }
}

private extension Styles {
    static let container = Layout.Style<UIView>(layout: {
        $0.flexGrow = 1
        $0.flexDirection = .column
        $0.justifyContent = .center
        $0.alignItems = .stretch
    })
    
    static let timeContainer = Layout.Style<UIView>(layout: {
        $0.flexGrow = 1
        $0.flexDirection = .row
        $0.alignItems = .flexStart
        $0.marginTop = 16
        $0.marginHorizontal = 16
    })
    
    static let currentTime = Layout.Style<UILabel>(layout: {
        $0.flexGrow = 1
    }) {
        $0.font = Font.smallCaption.uiFont
        $0.textAlignment = .left
        $0.textColor = Color.lightGray.uiColor
    }
    
    static let totalTime = Layout.Style<UILabel>(layout: {
        $0.flexGrow = 1
    }) {
        $0.font = Font.smallCaption.uiFont
        $0.textAlignment = .right
        $0.textColor = Color.lightGray.uiColor
    }
}

struct PlaybackProgressViewModel {
    let currentTime: TimeInterval?
    let totalTime: TimeInterval?
}

extension PlaybackProgress: ReactiveCompatible {
}

extension Reactive where Base: PlaybackProgress {
    var value: ControlProperty<Float> {
        return self.base.progressSlider.slider.rx.value
    }
    
    var playbackInfo: AnyObserver<PlaybackProgressViewModel> {
        return AnyObserver { event in
            if case let .next(viewModel) = event,
                let current = viewModel.currentTime,
                let total = viewModel.totalTime {
                
                self.base.currentTimeLabel.text = Format.trackDuration(current)
                self.base.totalTimeLabel.text = Format.trackDuration(total)
                
                self.base.progressSlider.slider.isEnabled = total != 0.0
                if total != 0.0 {
                    self.base.progressSlider.slider.value = Float(current / total)
                }
            }
        }
    }
}
