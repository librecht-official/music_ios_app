//
//  AudioPlayerViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import AVFoundation

class AudioPlayerViewController: UIViewController {
    private lazy var adaptiveView = AdaptiveAudioPlayerView()
    private lazy var player = Environment.current.audioPlayer
    private let disposeBag = DisposeBag()
    
    private var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(adaptiveView)
        bindUI(interfaceView: adaptiveView)
    }
    
    func bindUI(interfaceView: AdaptiveAudioPlayerView) {
        player.status
            .map { $0 == .readyToPlay }
            .drive(interfaceView.playbackControl.rx.isEnabled)
            .disposed(by: disposeBag)
        
        player.isPlaying
            .drive(interfaceView.playbackControl.playButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(player.currentPlaybackTime, player.currentPlaybackTotalTime)
            .map { PlaybackProgressViewModel(currentTime: $0, totalTime: $1) }
            .drive(interfaceView.rx.playbackInfo)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(player.playlist.asDriver(), player.currentTrack)
            .drive(onNext: { (playlist, currentTrack) in
                switch playlist {
                case .none:
                    interfaceView.set(albumCoverURL: nil)
                    interfaceView.set(title: Format.trackNoTitle)
                case let .album(album, startFrom: _):
                    interfaceView.set(albumCoverURL: album.coverImageURL)
                    interfaceView.set(title: Format.trackFullTitle(currentTrack, album: album))
                }
            })
            .disposed(by: disposeBag)
        
        interfaceView.rx.value
            .withLatestFrom(player.currentPlaybackTotalTime.filterNil()) { ($0, $1) }
            .map { TimeInterval($0) * $1 }
            .map { AudioPlayerCommand.seek(to: $0) }
            .bind(to: player.command)
            .disposed(by: disposeBag)
        
        interfaceView.playbackControl.playButton.rx.tap
            .withLatestFrom(player.isPlaying)
            .map { $0 ? AudioPlayerCommand.pause : .play }
            .bind(to: player.command)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adaptiveView.frame = view.bounds
    }
    
    func prepareForFirstKeyFrameMinimization() {
        adaptiveView.prepareForFirstKeyFrameMinimization()
    }
    
    func minimize() {
        adaptiveView.state = .minimized
    }
    
    func prepareForLastKeyFrameMinimization() {
        adaptiveView.prepareForLastKeyFrameMinimization()
    }
    
    func prepareForFirstKeyFrameMaximization() {
        adaptiveView.prepareForFirstKeyFrameMaximization()
    }
    
    func maximize() {
        adaptiveView.state = .maximized
    }
    
    func prepareForLastKeyFrameMaximization() {
        adaptiveView.prepareForLastKeyFrameMaximization()
    }
}
