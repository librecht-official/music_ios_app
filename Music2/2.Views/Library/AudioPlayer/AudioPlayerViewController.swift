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
import AVFoundation

class AudioPlayerViewController: UIViewController {
    private lazy var interfaceView = AudioPlayerView()
    private lazy var player = Environment.current.audioPlayer
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(interfaceView)
        view.constrain(subview: interfaceView)
        
        player.status
            .map { $0 == .readyToPlay }
            .drive(interfaceView.playbackControl.rx.isEnabled)
            .disposed(by: disposeBag)
        
        player.isPlaying
            .drive(interfaceView.playbackControl.playButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(player.currentPlaybackTime, player.currentPlaybackTotalTime)
            .map { PlaybackProgressViewModel(currentTime: $0, totalTime: $1) }
            .drive(interfaceView.playbackProgressView.rx.playbackInfo)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(player.playlist.asDriver(), player.currentTrack)
            .drive(onNext: { [unowned self] (playlist, currentTrack) in
                switch playlist {
                case .none:
                    self.interfaceView.set(albumCoverURL: nil)
                    self.interfaceView.titleLabel.text = Format.trackNoTitle
                case let .album(album, startFrom: _):
                    self.interfaceView.set(albumCoverURL: album.coverImageURL)
                    self.interfaceView.titleLabel.text = Format.trackFullTitle(currentTrack, album: album)
                }
            })
            .disposed(by: disposeBag)
        
        interfaceView.playbackProgressView.slider.rx.value
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
}
