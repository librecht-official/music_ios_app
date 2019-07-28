//
//  AudioPlayerView.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Kingfisher
import Layout

/// AudioPlayer's view with 2 states: minimized and maximized
class AdaptiveAudioPlayerView: UIView {
    // MARK: Style
    
    struct Style {
        let albumCoverPlaceholder = Asset.musicAlbumPlaceholder122x120
        let currentTime = LabelStyle(
            font: Font.smallCaption, textColor: Color.lightGray, alignment: .left
        )
        let totalTime = LabelStyle(
            font: Font.smallCaption, textColor: Color.lightGray, alignment: .right
        )
        let title = LabelStyle(
            font: Font.regularCaption, textColor: Color.blackText, alignment: .center
        )
        let smallTitle = LabelStyle(
            font: Font.smallCaption, textColor: Color.blackText, alignment: .right
        )
    }
    var style = Style() { didSet { apply(style: style) } }
    func apply(style: Style) {
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 8
        coverImageView.tintColor = Color.gray.uiColor
        coverImageView.image = style.albumCoverPlaceholder.image.template
        
        smallCoverImageView.clipsToBounds = true
        smallCoverImageView.layer.cornerRadius = 8
        smallCoverImageView.tintColor = Color.gray.uiColor
        smallCoverImageView.image = style.albumCoverPlaceholder.image.template
        
        sliderBackground.image = Asset.progressBackground3.image
        sliderBackground.clipsToBounds = true
        sliderBackground.layer.cornerRadius = 15
        
        slider.setMinimumTrackImage(Asset.playedProgress.image, for: .normal)
        slider.setMaximumTrackImage(Asset.remaingingProgress3.image, for: .normal)
        
        currentTimeLabel.apply(style: style.currentTime)
        totalTimeLabel.apply(style: style.totalTime)
        titleLabel.apply(style: style.title)
        smallTitleLabel.apply(style: style.smallTitle)
        smallTitleLabel.numberOfLines = 2
    }
    
    // MARK: Properties
    
    private(set) lazy var coverImageView = UIImageView()
    private(set) lazy var smallCoverImageView = UIImageView()
    private(set) lazy var coverMaskView = UIView()
    // FIXME: seeking backward doesn't work properly. Need to distinct events "sliding begin" and "sliding end". And perfom seeking the other way (Maybe even by replacing AVPlayerItem with the new one)
    private(set) lazy var slider: UISlider = Slider()
    private(set) lazy var sliderBackground = UIImageView()
    private(set) lazy var currentTimeLabel = UILabel()
    private(set) lazy var totalTimeLabel = UILabel()
    private(set) lazy var titleLabel = UILabel()
    private(set) lazy var smallTitleLabel = UILabel()
    private(set) lazy var playbackControl = PlaybackControl()
    private(set) lazy var volumeControl = VolumeControl()
    
    enum State {
        case minimized, maximized
    }
    var state: State = .minimized { didSet { setNeedsLayout() } }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(coverImageView)
        addSubview(smallCoverImageView)
        addSubview(smallTitleLabel)
        addSubview(sliderBackground)
        addSubview(slider)
        addSubview(currentTimeLabel)
        addSubview(totalTimeLabel)
        addSubview(titleLabel)
        addSubview(playbackControl)
        addSubview(volumeControl)
        
        coverMaskView.backgroundColor = UIColor.black
        coverImageView.mask = coverMaskView
        
        apply(style: style)
        
        currentTimeLabel.text = Format.undefinedDuration
        totalTimeLabel.text = Format.undefinedDuration
        titleLabel.text = Format.trackNoTitle
        smallTitleLabel.text = Format.trackNoTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch state {
        case .maximized: performMaximizedLayout()
        case .minimized: performMinimizedLayout()
        }
        let rect = convert(slider.frame, to: coverImageView)
        coverMaskView.frame = CGRect(
            x: 0, y: 0,
            width: coverImageView.bounds.width, height: max(0, rect.minY)
        )
    }
    
    private(set) lazy var maximizedLayout = Container(
        h: .h1(leading: 24, trailing: 24), v: .v1(top: 32, bottom: 32),
        relative: false,
        inner: Column(spacing: 16, [
            ColumnItem(
                AspectRatioComponent(
                    coverImageView, ratio: 1,
                    .v(.v1(top: 0, bottom: 0), and: .centerX(.abs(0)))
                ),
                length: .weight(3), bottom: 16
            ),
            ColumnItem(sliderLayout, length: .abs(28)),
            ColumnItem(
                Row(spacing: 8, [
                    RowItem(Component(currentTimeLabel), length: .weight(1)),
                    RowItem(Component(totalTimeLabel), length: .weight(1)),
                    ]
                ),
                length: .abs(20), top: -8
            ),
            ColumnItem(Component(titleLabel), length: .weight(1)),
            ColumnItem(Component(playbackControl), length: .weight(1), top: 8),
            ColumnItem(Component(volumeControl), length: .weight(1)),
            ]
        )
    )
    
    private lazy var sliderLayout = Container(
        sliderBackground, h: .zero, v: .zero, relative: false,
        inner: Component(slider)
    )
    
    private func performMaximizedLayout() {
        maximizedLayout.performLayout(inFrame: bounds)
        
        coverImageView.alpha = 1
        sliderBackground.alpha = 1
        slider.alpha = 1
        playbackControl.alpha = 1
        volumeControl.alpha = 1
    }
    
    private(set) lazy var minimizedLayout = Container(
        h: .h1(leading: 6, trailing: 6), v: .v2(top: 6, height: .abs(80)),
        relative: false,
        inner: Column(spacing: 12, [
            ColumnItem(sliderLayout, length: .abs(28)),
            ColumnItem(
                Row(spacing: 8, [
                    RowItem(Component(playbackControl), length: .weight(2), top: 4, bottom: 4),
                    RowItem(Component(smallTitleLabel), length: .weight(3)),
                    RowItem(
                        AspectRatioComponent(
                            smallCoverImageView, ratio: 1,
                            .h(.h1(leading: 0, trailing: 0), and: .centerY(.abs(0)))),
                        length: .abs(38)
                    )
                    ]
                ),
                length: .weight(1), leading: 10, trailing: 10
            )
            ]
        )
    )
    
    private func performMinimizedLayout() {
        // To perfrom right animation between minimized and maximazed states, frames of some views that are not visible in minimized state (their frames remains unchanged in minimazed state) should be calculated first.
        performMaximizedLayout()
        
        minimizedLayout.performLayout(inFrame: bounds)
        
        coverImageView.alpha = 0
        sliderBackground.alpha = 1
        slider.alpha = 1
        playbackControl.alpha = 1
        volumeControl.alpha = 0
    }
    
    // MARK: Configuration
    
    func set(albumCoverURL url: URL?) {
        let placeholder = style.albumCoverPlaceholder.image.template
        coverImageView.kf.setImage(with: url, placeholder: placeholder)
        smallCoverImageView.kf.setImage(with: url, placeholder: placeholder)
    }
    
    func set(title: String) {
        titleLabel.text = title
        smallTitleLabel.text = title
    }
    
    func prepareForFirstKeyFrameMinimization() {
        smallCoverImageView.alpha = 0
        smallTitleLabel.alpha = 0
        titleLabel.alpha = 0
        currentTimeLabel.alpha = 0
        totalTimeLabel.alpha = 0
    }
    
    func prepareForLastKeyFrameMinimization() {
        smallCoverImageView.alpha = 1
        smallTitleLabel.alpha = 1
        titleLabel.alpha = 0
        currentTimeLabel.alpha = 0
        totalTimeLabel.alpha = 0
    }
    
    func prepareForFirstKeyFrameMaximization() {
        smallCoverImageView.alpha = 0
        smallTitleLabel.alpha = 0
        titleLabel.alpha = 0
        currentTimeLabel.alpha = 0
        totalTimeLabel.alpha = 0
    }
    
    func prepareForLastKeyFrameMaximization() {
        smallCoverImageView.alpha = 0
        smallTitleLabel.alpha = 0
        titleLabel.alpha = 1
        currentTimeLabel.alpha = 1
        totalTimeLabel.alpha = 1
    }
}

// MARK: - Slider

private final class Slider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.size.height = 28
        return rect
    }
}

// MARK: - Rx

import RxSwift
import RxCocoa

struct PlaybackProgressViewModel {
    let currentTime: TimeInterval?
    let totalTime: TimeInterval?
}

extension Reactive where Base: AdaptiveAudioPlayerView {
    var value: ControlProperty<Float> {
        return self.base.slider.rx.value
    }
    
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
