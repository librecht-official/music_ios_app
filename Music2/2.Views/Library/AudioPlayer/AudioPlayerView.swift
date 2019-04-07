//
//  AudioPlayerView.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Kingfisher
import YogaKit

//class AudioPlayerView: LayoutView {
//    private(set) lazy var coverImageView = UIImageView()
//    private(set) lazy var playbackProgress = PlaybackProgress()
//    private(set) lazy var titleLabel = UILabel()
//    private(set) lazy var playbackControl = PlaybackControl()
//    private(set) lazy var volumeControl = VolumeControl()
//    
//    fileprivate func minimizedLayout() -> LayoutNode {
//        return Layout.Composite(self, style: Styles.Minimized.container, [
//            Layout.Component(playbackProgress.progressSlider),
//            Layout.Composite(UIView(), style: Styles.Minimized.playbackAndInfo, [
//                Layout.Component(playbackControl),
//                Layout.Label(titleLabel, style: Styles.Minimized.title),
//                Layout.Image(coverImageView, style: Styles.Minimized.albumCover),
//            ])
//        ])
//    }
//    
//    fileprivate func maximizedLayout() -> LayoutNode {
//        return Layout.Composite(self, style: Styles.container, [
//            Layout.Image(coverImageView, style: Styles.albumCover),
//            Layout.Component(playbackProgress),
//            Layout.Label(titleLabel, style: Styles.title),
//            Layout.Component(playbackControl),
//            Layout.Composite(UIView(), style: Styles.volumeContainer, [
//                Layout.Component(volumeControl)
//            ])
//        ])
//    }
//    
//    func set(albumCoverURL url: URL?) {
//        coverImageView.kf.setImage(with: url, placeholder: Asset.musicAlbumPlaceholder122x120.image)
//    }
//}
//
//class MinimizedAudioPlayerView: AudioPlayerView {
//    convenience init() {
//        self.init(frame: .zero)
//        minimizedLayout().configureLayout()
//        titleLabel.text = Format.trackNoTitle
//    }
//}
//
//class MaximizedAudioPlayerView: AudioPlayerView {
//    convenience init() {
//        self.init(frame: .zero)
//        maximizedLayout().configureLayout()
//        titleLabel.text = Format.trackNoTitle
//    }
//}
//
//private extension Styles {
//    enum Minimized {
//        static let container = Layout.Style<UIView>(layout: {
//            $0.flexGrow = 1
//            $0.flexDirection = .column
//            $0.justifyContent = .spaceBetween
//            $0.alignItems = .stretch
//            $0.margin = 3
//            $0.height = 92
//        })
//        
//        static let playbackAndInfo = Layout.Style<UIView>(layout: {
//            $0.flexGrow = 2
//            $0.flexDirection = .row
//            $0.justifyContent = .spaceBetween
//            $0.alignItems = .stretch
//        })
//        
//        static let title = Layout.Style<UILabel>(layout: {
//            $0.flexGrow = 2
//            $0.margin = 8
//        }) {
//            $0.numberOfLines = 0
//            $0.textAlignment = .center
//        }
//        
//        static let albumCover = Layout.Style<UIImageView>(layout: {
////            $0.flexGrow = 0.5
//            $0.aspectRatio = 1
//            $0.margin = 8
//            $0.height = 66
//        }) {
//            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 8
//            $0.tintColor = Color.gray.uiColor
//            $0.image = Asset.musicAlbumPlaceholder122x120.image.withRenderingMode(.alwaysTemplate)
//        }
//    }
//    
//    static let container = Layout.Style<UIView>(layout: {
//        $0.flexGrow = 1
//        $0.flexDirection = .column
//        $0.justifyContent = .spaceBetween
//        $0.alignItems = .stretch
//        $0.marginHorizontal = 8
//        $0.marginBottom = 32
//    })
//    
//    static let albumCover = Layout.Style<UIImageView>(layout: {
//        $0.flexGrow = 3
//        $0.aspectRatio = 1
//        $0.alignSelf = .center
//        $0.marginVertical = 32
//    }) {
//        $0.clipsToBounds = true
//        $0.layer.cornerRadius = 8
//        $0.tintColor = Color.gray.uiColor
//        $0.image = Asset.musicAlbumPlaceholder122x120.image.withRenderingMode(.alwaysTemplate)
//    }
//    
//    static let title = Layout.Style<UILabel>(layout: {
//        $0.flexGrow = 1
//        $0.margin = 8
//        $0.marginBottom = 16
//    }) {
//        $0.textAlignment = .center
//    }
//    
//    static let volumeContainer = Layout.Style(layout: {
//        $0.flexGrow = 1
//        $0.marginTop = 32
//        $0.marginBottom = 16
//        $0.justifyContent = .flexEnd
//    })
//}

class AdaptiveAudioPlayerView: UIView {
    private(set) lazy var coverImageView = UIImageView()
    private(set) lazy var smallCoverImageView = UIImageView()
    
    private(set) lazy var coverMaskView = UIView()
    
    private(set) lazy var slider: UISlider = Slider()
    private(set) lazy var imageView = UIImageView()
    
    private(set) lazy var currentTimeLabel = UILabel()
    private(set) lazy var totalTimeLabel = UILabel()
    
    private(set) lazy var titleLabel = UILabel()
    private(set) lazy var smallTitleLabel = UILabel()
    let playbackControl = PlaybackControl()
    private let playbackControlView: UIView
    let volumeControl = VolumeControl()
    private let volumeControlView: UIView
    
    enum State {
        case minimized, maximized
    }
    var state: State = .minimized {
        didSet {
            setNeedsLayout()
        }
    }
    
    init() {
        self.playbackControlView = playbackControl.render().configureLayout()
        self.volumeControlView = volumeControl.render().configureLayout()
        super.init(frame: .zero)
        
        addSubview(coverImageView)
        addSubview(smallCoverImageView)
        addSubview(smallTitleLabel)
        addSubview(imageView)
        addSubview(slider)
        addSubview(currentTimeLabel)
        addSubview(totalTimeLabel)
        addSubview(titleLabel)
        addSubview(playbackControlView)
        addSubview(volumeControlView)
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 8
        coverImageView.tintColor = Color.gray.uiColor
        coverImageView.image = Asset.musicAlbumPlaceholder122x120.image.withRenderingMode(.alwaysTemplate)
        
        smallCoverImageView.clipsToBounds = true
        smallCoverImageView.layer.cornerRadius = 8
        smallCoverImageView.tintColor = Color.gray.uiColor
        smallCoverImageView.image = Asset.musicAlbumPlaceholder122x120.image.withRenderingMode(.alwaysTemplate)
        
        coverMaskView.backgroundColor = UIColor.black
        coverImageView.mask = coverMaskView
        
        imageView.image = Asset.progressBackground3.image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        
        slider.setMinimumTrackImage(Asset.playedProgress.image, for: .normal)
        slider.setMaximumTrackImage(Asset.remaingingProgress3.image, for: .normal)
        
        currentTimeLabel.font = Font.smallCaption.uiFont
        currentTimeLabel.textAlignment = .left
        currentTimeLabel.textColor = Color.lightGray.uiColor
        
        totalTimeLabel.font = Font.smallCaption.uiFont
        totalTimeLabel.textAlignment = .right
        totalTimeLabel.textColor = Color.lightGray.uiColor
        
        titleLabel.textAlignment = .center
        titleLabel.font = Font.regularCaption.uiFont
        smallTitleLabel.textAlignment = .right
        smallTitleLabel.font = Font.smallCaption.uiFont
        smallTitleLabel.numberOfLines = 2
        
        volumeControlView.tintColor = Color.black.uiColor
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
        Layout.applyLayout(playbackControlView)
        Layout.applyLayout(volumeControlView)
        
        coverMaskView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: slider.frame.origin.y)
    }
    
    private func maximizedLayout() {
        // TODO: tidy up this mess
        var h = bounds.height / 3
        coverImageView.frame = CGRect(x: 16, y: 16, width: h, height: h)
        coverImageView.center = CGPoint(x: center.x, y: coverImageView.center.y)
        
        var w = bounds.width
        slider.frame = CGRect(x: 16, y: coverImageView.frame.maxY + 16, width: w - 32, height: 28)
        imageView.frame = slider.frame
        
        var y = imageView.frame.maxY + 8
        w = bounds.width / 2 - 16 - 8
        currentTimeLabel.frame = CGRect(x: 16, y: y, width: w, height: 20)
        var x = currentTimeLabel.frame.maxX + 8
        totalTimeLabel.frame = CGRect(x: x, y: y, width: w, height: 20)
        
        y = totalTimeLabel.frame.maxY + 16
        w = bounds.width - 32
        titleLabel.frame = CGRect(x: 16, y: y, width: w, height: 20)
        
        y = titleLabel.frame.maxY + 16
        playbackControlView.frame = CGRect(x: 16, y: y, width: w, height: 46)
        
        y = playbackControlView.frame.maxY + 16
        volumeControlView.frame = CGRect(x: 16, y: y, width: w, height: 44)
        
        coverImageView.alpha = 1
        imageView.alpha = 1
        slider.alpha = 1
        playbackControlView.alpha = 1
        volumeControlView.alpha = 1
    }
    
    private func minimizedLayout() {
        var h = bounds.height / 3
        coverImageView.frame = CGRect(x: 16, y: 16, width: h, height: h)
        coverImageView.center = CGPoint(x: center.x, y: coverImageView.center.y)
        
        var w = bounds.width - 12
        slider.frame = CGRect(x: 6, y: 6, width: w, height: 28)
        imageView.frame = slider.frame
        
        var y = slider.frame.maxY + 12
        playbackControlView.frame = CGRect(x: 16, y: y, width: 0.4 * bounds.width, height: 38)
        
        y = slider.frame.maxY + 12
        h = CGFloat(38)
        var x = bounds.width - 27 - h
        smallCoverImageView.frame = CGRect(x: x, y: y, width: h, height: h)
        
        x = playbackControlView.frame.maxX + 8
        y = slider.frame.maxY + 12
        w = smallCoverImageView.frame.minX - playbackControlView.frame.maxX - 16
        smallTitleLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        
        volumeControlView.frame = CGRect(x: 16, y: bounds.height, width: bounds.width - 32, height: 44)
        
        coverImageView.alpha = 0
        imageView.alpha = 1
        slider.alpha = 1
        playbackControlView.alpha = 1
        volumeControlView.alpha = 0
    }
    
    let placeholer = Asset.musicAlbumPlaceholder122x120.image
    func set(albumCoverURL url: URL?) {
        coverImageView.kf.setImage(with: url, placeholder: placeholer)
        smallCoverImageView.kf.setImage(with: url, placeholder: placeholer)
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
