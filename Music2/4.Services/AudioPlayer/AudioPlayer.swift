//
//  AudioPlayer.swift
//  Music2
//
//  Created by Vladislav Librecht on 18.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

// MARK: - AudioPlayerPlaylist

enum AudioPlayerPlaylist: Equatable {
    case none
    case album(Album, startFrom: Int)
    
    var tracks: [MusicTrack] {
        switch self {
        case .none:
            return []
        case let .album(album, startFrom: index):
            return Array(album.tracks.suffix(from: index))
        }
    }
}

// MARK: - AudioPlayerCommand

enum AudioPlayerCommand {
    case play
    case pause
    case seek(to: TimeInterval)
}

// MARK: - AudioPlayer

protocol AudioPlayer {
    var status: Driver<AVPlayer.Status> { get }
    var currentPlaybackTime: Driver<TimeInterval> { get }
    var currentPlaybackTotalTime: Driver<TimeInterval?> { get }
    var isPlaying: Driver<Bool> { get }
    var playlist: BehaviorRelay<AudioPlayerPlaylist> { get }
    var currentTrack: Driver<MusicTrack?> { get }
    
    var command: AnyObserver<AudioPlayerCommand> { get }
}

// MARK: - AppAudioPlayer

class AppAudioPlayer: AudioPlayer {
    private let player = AVPlayer(playerItem: nil)
    let playlist = BehaviorRelay<AudioPlayerPlaylist>(value: .none)
    private var currentTrackIndex: Int? {
        didSet {
            let track = currentTrackIndex.map { playlist.value.tracks[$0] }
            currentTrackSubject.onNext(track)
        }
    }
    private let commandSubject = PublishSubject<AudioPlayerCommand>()
    private let currentTrackSubject = PublishSubject<MusicTrack?>()
    private let disposeBag = DisposeBag()
    
    init() {
        commandSubject
            .subscribe(onNext: { [unowned self] command in
                self.dispatch(command: command)
            })
            .disposed(by: disposeBag)
        
        playlist
            .subscribe(onNext: { [unowned self] list in
                self.player.replaceCurrentItem(with: nil)
                self.currentTrackIndex = list.tracks.isEmpty ? nil : 0
            })
            .disposed(by: disposeBag)
        
        player.rx.currentItem
            .flatMap { item -> Observable<Bool> in
                if let item = item {
                    return item.rx.didPlayToEnd.map { _ in true }
                }
                else {
                    return .just(false)
                }
            }
            .subscribe(onNext: { [unowned self] nextTrack in
                self.playNextTrack(nextTrack)
            })
            .disposed(by: disposeBag)
    }
    
    var status: Driver<AVPlayer.Status> {
        return player.rx.status.asDriver(onErrorJustReturn: .unknown)
    }
    
    var currentPlaybackTime: Driver<TimeInterval> {
        return player.rx.playbackTime(0.5).asDriver(onErrorJustReturn: 0.0)
    }
    
    var currentPlaybackTotalTime: Driver<TimeInterval?> {
        return player.rx.currentItem
            .map { [unowned self] item -> TimeInterval? in
                if let i = self.currentTrackIndex, item != nil {
                    return self.playlist.value.tracks[i].durationSec
                }
                return nil
            }
            .asDriver(onErrorJustReturn: 0.0)
    }
    
    var isPlaying: Driver<Bool> {
        return player.rx.isPlaying.asDriver(onErrorJustReturn: false)
    }
    
    var currentTrack: Driver<MusicTrack?> {
        return currentTrackSubject.asDriver(onErrorJustReturn: nil)
    }
    
    var command: AnyObserver<AudioPlayerCommand> {
        return commandSubject.asObserver()
    }
    
    func play() {
        if player.currentItem != nil && player.currentItem?.status == .readyToPlay {
            player.play()
        }
        else {
            playNewItem()
        }
    }
    
    func playNewItem() {
        if let i = currentTrackIndex, let next = playlist.value.tracks[i].audioURL {
            let item = AVPlayerItem(url: next)
            player.replaceCurrentItem(with: item)
            player.play()
        }
    }
    
    func playNextTrack(_ nextTrack: Bool) {
        if nextTrack == false {
            currentTrackIndex = nil
            return
        }
        if let current = currentTrackIndex,
            let i = playlist.value.tracks.nextPlayableElement(startingFrom: current + 1)?.0 {
            self.currentTrackIndex = i
            self.playNewItem()
        }
        else if !self.playlist.value.tracks.isEmpty,
            let i = self.playlist.value.tracks.nextPlayableElement(startingFrom: 0)?.0 {
            self.currentTrackIndex = i
            self.play()
        } else {
            self.currentTrackIndex = nil
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func seek(to time: TimeInterval) {
        let t = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.pause()
        player.seek(to: t, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
            self.player.play()
        }
    }
    
    func dispatch(command: AudioPlayerCommand) {
        switch command {
        case .play:
            play()
        case .pause:
            pause()
        case .seek(to: let time):
            seek(to: time)
        }
    }
}
