//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Layout
import Core


/// AudioPlayer's view with 2 states: minimized and maximized
public class AdaptiveAudioPlayerView: UIView {
    typealias Run = (AdaptiveAudioPlayerViewType) -> Driver<Void>
    func bind(_ run: Run) {
        run(self).drive().disposed(by: disposeBag)
    }
    
    private(set) lazy var coverImageView = UIImageView()
    private(set) lazy var smallCoverImageView = UIImageView()
    private(set) lazy var coverMaskView = UIView()
    private(set) lazy var slider = PlaybackProgressSlider()
    private(set) lazy var sliderBackground = UIImageView()
    private(set) lazy var currentTimeLabel = MUSLabel()
    private(set) lazy var totalTimeLabel = MUSLabel()
    private(set) lazy var titleLabel = MUSLabel()
    private(set) lazy var smallTitleLabel = MUSLabel()
    private(set) lazy var playbackControl = PlaybackControl()
    private(set) lazy var volumeControl = VolumeControl()
    
    private let disposeBag = DisposeBag()
    
    enum State {
        case minimized, maximized
    }
    var state: State = .minimized { didSet { setNeedsLayout() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
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
        
        titleLabel.numberOfLines = 0
        smallTitleLabel.numberOfLines = 2
        coverMaskView.backgroundColor = UIColor.black
        coverImageView.mask = coverMaskView
    }
    
    // MARK: Layout
    
    public override func layoutSubviews() {
        apply(stylesheet: stylesheet())
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
    
    private(set) lazy var maximizedLayout = VirtualContainer(
        .h1(leading: 24, trailing: 24), .v1(top: 32, bottom: 32),
        sub: Column(spacing: 16, [
            ColumnItem.fixed(height: .weight(3),
                AspectRatioComponent(
                    coverImageView, ratio: 1,
                    .v(.v1(top: 0, bottom: 0), and: .centerX(.abs(0)))
                ),
                Insets(bottom: 16)
            ),
            ColumnItem.fixed(height: .abs(28), sliderLayout),
            ColumnItem.fixed(height: .abs(20),
                Row(spacing: 8, [
                    RowItem.fixed(width: .weight(1), Component(currentTimeLabel)),
                    RowItem.fixed(width: .weight(1), Component(totalTimeLabel)),
                    ]
                ),
                Insets(top: -8)
            ),
            ColumnItem.fixed(height: .weight(1), Component(titleLabel)),
            ColumnItem.fixed(height: .weight(1), Component(playbackControl), Insets(top: 8)),
            ColumnItem.fixed(height: .weight(1), Component(volumeControl)),
            ]
        )
    )
    
    private lazy var sliderLayout = Container(
        sliderBackground, .zero, .zero, relative: false,
        sub: Component(slider)
    )
    
    private func performMaximizedLayout() {
        maximizedLayout.performLayout(inFrame: bounds)
        
        coverImageView.alpha = 1
        sliderBackground.alpha = 1
        slider.alpha = 1
        playbackControl.alpha = 1
        volumeControl.alpha = 1
    }
    
    private(set) lazy var minimizedLayout = VirtualContainer(
        .h1(leading: 6, trailing: 6), .v2(top: 6, height: .abs(80)),
        sub: Column(spacing: 12, [
            ColumnItem.fixed(height: .abs(28), sliderLayout),
            ColumnItem.fixed(
                height: .weight(1),
                Row(spacing: 8, [
                    RowItem.fixed(width: .weight(2), Component(playbackControl), Insets(top: 4, bottom: 4)),
                    RowItem.fixed(width: .weight(3), Component(smallTitleLabel)),
                    RowItem.fixed(width: .abs(38),
                        AspectRatioComponent(
                            smallCoverImageView, ratio: 1,
                            .h(.h1(leading: 0, trailing: 0), and: .centerY(.abs(0)))
                        ))
                    ]
                ),
                Insets(leading: 10, trailing: 10)
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
    
    // MARK: Stylization
    
    func apply(stylesheet: StylesheetType) {
        coverImageView.clipsToBounds = true
        coverImageView.tintColor = stylesheet.color.gray1
        coverImageView.contentMode = .scaleAspectFill
        stylesheet.cornerRadius.normal(coverImageView)
        
        smallCoverImageView.tintColor = stylesheet.color.gray1
        smallCoverImageView.contentMode = .scaleAspectFill
        stylesheet.cornerRadius.small(smallCoverImageView)
        
        // TODO: Slider
        
        currentTimeLabel.textAlignment = .left
        stylesheet.text.minorFootnote(currentTimeLabel)
        totalTimeLabel.textAlignment = .right
        stylesheet.text.minorFootnote(totalTimeLabel)
        
        titleLabel.textAlignment = .center
        stylesheet.text.title3(titleLabel)
        smallTitleLabel.textAlignment = .right
        stylesheet.text.smallBody(smallTitleLabel)
    }
    
    // MARK: Configuration
    
    func set(albumCoverURL url: URL?) {
        let placeholder = stylesheet().image.musicAlbumPlaceholderLarge.template
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

// MARK: - AdaptiveAudioPlayerViewType

extension AdaptiveAudioPlayerView: AdaptiveAudioPlayerViewType {
    var playbackControlEnabled: Binder<Bool> { playbackControl.rx.isEnabled }
    var playButtonSelected: Binder<Bool> { playbackControl.playButton.rx.isSelected }
    var currentTime: Binder<String?> { currentTimeLabel.rx.text }
    var totalTime: Binder<String?> { totalTimeLabel.rx.text }
    var progressSliderEnabled: Binder<Bool> { slider.rx.isEnabled }
    var progressSliderValue: ControlProperty<Float> { slider.rx.value }
    var albumCoverURL: Binder<URL?> {
        Binder<URL?>.init(self) { (self, url) in
            self.set(albumCoverURL: url)
        }
    }
    var title: Binder<String> {
        Binder<String>.init(self) { (self, title) in
            self.set(title: title)
        }
    }
    var progressSliderValueChanged: Signal<Float> {
        slider.rx.value.asSignal(onErrorSignalWith: .never())
    }
    var playButtonTap: Signal<Void> { playbackControl.playButton.rx.tap.asSignal() }
}
