//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa
import RxOptional
import RxFeedback
import Core


public enum AudioPlayerSystemCommand {
    case setPlaylist(AudioPlayerPlaylist)
    case play
    case pause
    case seek(to: TimeInterval)
}

public protocol AudioPlayerSystem {
    var command: PublishRelay<AudioPlayerSystemCommand> { get }
    
    var status: Driver<AVPlayer.Status> { get }
    var currentPlaybackTime: Driver<TimeInterval> { get }
    var currentPlaybackTotalTime: Driver<TimeInterval?> { get }
    var isPlaying: Driver<Bool> { get }
    var playlist: Driver<AudioPlayerPlaylist> { get }
    var currentTrack: Driver<Core.MusicTrack?> { get }
}

public class AppAudioPlayerSystem: AudioPlayerSystem {
    typealias State = AudioPlayer.State
    typealias Command = AudioPlayer.Command
    
    let player = AVPlayer(playerItem: nil)
    public let command = PublishRelay<AudioPlayerSystemCommand>()
    private let disposeBag = DisposeBag()
    
    // MARK: AudioPlayerSystem
    
    public var status: Driver<AVPlayer.Status> {
        return player.rx.status.asDriver(onErrorJustReturn: .unknown)
    }
    
    public var currentPlaybackTime: Driver<TimeInterval> {
        return player.rx.playbackTime(0.5).asDriver(onErrorJustReturn: 0.0)
    }
    
    public var currentPlaybackTotalTime: Driver<TimeInterval?> {
        return state.map { $0.currentTrack?.durationSec }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
    }
    
    public var isPlaying: Driver<Bool> {
        return player.rx.isPlaying.asDriver(onErrorJustReturn: false)
    }
    
    var currentTrackRelay = BehaviorRelay<Core.MusicTrack?>(value: nil)
    public var currentTrack: Driver<Core.MusicTrack?> {
        return currentTrackRelay.asDriver(onErrorJustReturn: nil)
    }
    
    var playlistRelay = BehaviorRelay<AudioPlayerPlaylist>(value: .none)
    public var playlist: Driver<AudioPlayerPlaylist> {
        return playlistRelay.asDriver(onErrorJustReturn: .none)
    }
    
    var state = PublishSubject<State>()
    
    // MARK: Init
    
    public init() {
        let bindAV: Feedback.Loop<State, Command> = bind(self) { (self, state) -> Bindings<Command> in
            let stateToAV = [
                state.map { $0.nextAction }.filterNil().drive(self.dispatchAction),
                state.map { $0.playlist }.drive(self.playlistRelay),
                state.map { $0.currentTrack }.drive(self.currentTrackRelay)
            ]
            let avToCommands = [
                self.player.rx.currentItemDidPlayToEnd.map { _ in Command.playingItemFinished },
                self.command.asSignal().map(AudioPlayerSystemCommand.toPlayerCommand),
                self.didSeekRelay.asSignal().map { Command.didSeek(to: $0) },
                self.player.rx.currentItem.map { Command.currentItemIsSet($0 != nil) }
                    .asSignal(onErrorSignalWith: .never())
            ]
            
            return Bindings(subscriptions: stateToAV, events: avToCommands)
        }
        
        let system = Driver.system(
            initialState: AudioPlayer.State(),
            reduce: AudioPlayer.reduce,
            feedback: bindAV
        )
        system.drive(state).disposed(by: disposeBag)
    }
    
    // MARK: Private
    
    private var didSeekRelay = PublishRelay<TimeInterval>()
    private var dispatchAction: Binder<AudioPlayer.State.NextAction> {
        return Binder(self) { (system, action) in
            let player = system.player
            switch action {
            case let .playNewItem(track):
                let item = AVPlayerItem(url: track.audioURL)
                player.replaceCurrentItem(with: item)
                player.play()
                
            case .pauseCurrentItem:
                player.pause()
                
            case .playCurrentItem:
                player.play()
                
            case let .seek(to: time):
                let t = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                player.pause()
                player.seek(to: t, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
                    print("seek to finished: \(finished)")
                    player.play()
                    system.didSeekRelay.accept(time)
                }
            }
        }
    }
}

extension AudioPlayerSystemCommand {
    static func toPlayerCommand(_ systemCommand: AudioPlayerSystemCommand) -> AudioPlayer.Command {
        switch systemCommand {
        case let .setPlaylist(playlist): return .setPlaylist(playlist)
        case .play: return .resume
        case .pause: return .pause
        case let .seek(to: time): return .seek(to: time)
        }
    }
}
