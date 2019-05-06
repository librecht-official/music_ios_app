//
//  AudioPlayerView.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Kingfisher

class AdaptiveAudioPlayerView: UIView {
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
    
    private(set) lazy var coverImageView = UIImageView()
    private(set) lazy var smallCoverImageView = UIImageView()
    private(set) lazy var coverMaskView = UIView()
    // FIXME: seeking backward doesn't work properly. Need to distinct events "sliding begin" and "sliding end". And perfom seeking the other way (Maybe even by replacing AVPlayerItem with the nwe one)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch state {
        case .maximized: maximizedLayout()
        case .minimized: minimizedLayout()
        }
        let rect = convert(slider.frame, to: coverImageView)
        coverMaskView.frame = CGRect(x: 0, y: 0, width: coverImageView.bounds.width, height: max(0, rect.minY))
    }
    
    private func maximizedLayout() {
        let content = layout(
            LayoutRules(
                h: .h1(leading: 24, trailing: 24),
                v: .v1(top: 32, bottom: 32)
            ),
            inFrame: bounds
        )
        var coverImageContainer = CGRect.zero
        var playbackTimeContainer = CGRect.zero
        stackColumn(
            alignment: .fill, spacing: 16, [
                StackItem({ coverImageContainer = $0 }, length: .weight(3), bottom: 16),
                StackItem({ self.slider.frame = $0 }, length: .abs(28)),
                StackItem({ playbackTimeContainer = $0 }, length: .abs(20), top: -8),
                StackItem({ self.titleLabel.frame = $0 }, length: .weight(1)),
                StackItem({ self.playbackControl.frame = $0 }, length: .weight(1), top: 8),
                StackItem({ self.volumeControl.frame = $0 }, length: .weight(1)),
            ],
            inFrame: content
        )
        coverImageView.frame = layout(
            aspectRatio: 1, .v(.v1(top: 0, bottom: 0), and: .centerX(.abs(0))),
            inFrame: coverImageContainer
        )
        sliderBackground.frame = slider.frame
        stackRow(
            alignment: .fill, spacing: 8, [
                StackItem({ self.currentTimeLabel.frame = $0 }, length: .weight(1)),
                StackItem({ self.totalTimeLabel.frame = $0 }, length: .weight(1))
            ],
            inFrame: playbackTimeContainer
        )
        coverImageView.alpha = 1
        sliderBackground.alpha = 1
        slider.alpha = 1
        playbackControl.alpha = 1
        volumeControl.alpha = 1
    }
    
    private func minimizedLayout() {
        maximizedLayout()
        
        let content = layout(
            LayoutRules(h: .h1(leading: 6, trailing: 6), v: .v2(top: 6, height: .abs(80))),
            inFrame: bounds
        )
        var bottom = CGRect.zero
        stackColumn(
            alignment: .fill, spacing: 12, [
                StackItem({ self.slider.frame = $0 }, length: .abs(28)),
                StackItem({ bottom = $0 }, length: .weight(1), leading: 10, trailing: 10),
            ],
            inFrame: content
        )
        sliderBackground.frame = slider.frame
        var smallCoverContainer = CGRect.zero
        stackRow(
            alignment: .fill, spacing: 8, [
                StackItem({ self.playbackControl.frame = $0 }, length: .weight(2), top: 4, bottom: 4),
                StackItem({ self.smallTitleLabel.frame = $0 }, length: .weight(3)),
                StackItem({ smallCoverContainer = $0 }, length: .abs(38))
            ],
            inFrame: bottom
        )
        smallCoverImageView.frame = layout(
            aspectRatio: 1, .h(.h1(leading: 0, trailing: 0), and: .centerY(.abs(0))),
            inFrame: smallCoverContainer
        )
        
        coverImageView.alpha = 0
        sliderBackground.alpha = 1
        slider.alpha = 1
        playbackControl.alpha = 1
        volumeControl.alpha = 0
    }
    
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

private final class Slider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.size.height = 28
        return rect
    }
}

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
