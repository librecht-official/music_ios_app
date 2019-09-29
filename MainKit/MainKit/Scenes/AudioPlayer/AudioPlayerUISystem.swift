//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import Core


protocol AdaptiveAudioPlayerViewType: AnyObject {
    var playbackControlEnabled: Binder<Bool> { get }
    var playButtonSelected: Binder<Bool> { get }
    var currentTime: Binder<String?> { get }
    var totalTime: Binder<String?> { get }
    var progressSliderEnabled: Binder<Bool> { get }
    var progressSliderValue: ControlProperty<Float> { get }
    var albumCoverURL: Binder<URL?> { get }
    var title: Binder<String> { get }
    
    var progressSliderValueChanged: Signal<Float> { get }
    var playButtonTap: Signal<Void> { get }
}

extension AudioPlayerUI {
    public typealias Env = AudioPlayerEnvironment
    typealias Loop = Feedback.Loop<State, Event>

    static func run(env: Env, view: AdaptiveAudioPlayerViewType) -> Driver<Void> {
        let uiBinding: Loop = bind { [weak view] state -> Bindings<Event> in
            guard let view = view else { return .empty() }
            
            return Bindings<Event>.init(subscriptions: [
                state.map { $0.playbackControlEnabled }.drive(view.playbackControlEnabled),
                state.map { $0.playButtonSelected }.drive(view.playButtonSelected),
                state.map { $0.currentTime }.map(Format.trackDuration).drive(view.currentTime),
                state.map { $0.totalTime }.map(Format.trackDuration).drive(view.totalTime),
                state.map { $0.progressSliderEnabled }.drive(view.progressSliderEnabled),
                state.map { $0.progressSliderValue }.drive(view.progressSliderValue),
                state.map { $0.albumCoverURL }.distinctUntilChanged().drive(view.albumCoverURL),
                state.map { $0.title }.distinctUntilChanged().drive(view.title)
            ], events: [
                view.progressSliderValueChanged.map { Event.progressSliderValueChanged($0) },
                view.playButtonTap.map { Event.playButtonTap }
            ])
        }
        
        let player = env.audioPlayer
        let playerLoop: Loop = { state -> Signal<Event> in
            Driver.merge([
                player.status
                    .map { $0 == .readyToPlay }
                    .map { Event.playerIsReadyToPlay($0) },
                player.isPlaying
                    .map { Event.playerIsPlaying($0) },

                Driver.combineLatest(player.currentPlaybackTime, player.currentPlaybackTotalTime)
                    .map { Event.playbackProgressChanged(currentTime: $0, totalTime: $1) },

                Driver.combineLatest(player.currentTrack, player.playlist.asDriver())
                    .map { Event.playerCurrentTrackChanged(track: $0, playlist: $1) }
            ])
            .asSignal(onErrorSignalWith: .empty())
        }

        let effectsLoop: Loop = react(request: { $0.effect }) { request -> Signal<Event> in
            switch request.data {
            case let .setPlayerCommands(commands):
                commands.forEach { cmd in env.audioPlayer.command.accept(cmd) }
                return .never()
            }
        }

        return Driver.system(
            initialState: State(),
            reduce: reduce,
            feedback: [uiBinding, playerLoop, effectsLoop]
        )
            .map { _ in () }
    }
}
