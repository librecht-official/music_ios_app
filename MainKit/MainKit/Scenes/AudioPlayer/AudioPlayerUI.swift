//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation
import Core


enum AudioPlayerUI {
    struct State {
        var isPlaying: Bool = false
        var playbackControlEnabled: Bool = false
        
        var currentTime: TimeInterval? = nil
        var totalTime: TimeInterval? = nil
        var progressSliderEnabled: Bool = false
        var progressSliderValue: Float = 0
        var albumCoverURL: URL? = nil
        var title: String = Format.trackNoTitle

        var effect: Feedback.Request<Effect>?
        
        var playButtonSelected: Bool {
            return isPlaying
        }
    }

    enum Event {
        case playerIsReadyToPlay(Bool)
        case playerIsPlaying(Bool)
        case playbackProgressChanged(currentTime: TimeInterval, totalTime: TimeInterval?)
        case playerCurrentTrackChanged(track: Core.MusicTrack?, playlist: AudioPlayerPlaylist)

        case progressSliderValueChanged(Float)
        case playButtonTap
    }

    enum Effect {
        case setPlayerCommands([AudioPlayerSystemCommand])
    }

    static func reduce(state: State, event: Event) -> State {
        var state = state
        switch event {
        case let .playerIsReadyToPlay(isReady):
            state.playbackControlEnabled = isReady

        case let .playerIsPlaying(isPlaying):
            state.isPlaying = isPlaying

        case let .playbackProgressChanged(currentTime, totalTime):
            state.currentTime = currentTime
            state.totalTime = totalTime
            let total = totalTime ?? 0
            state.progressSliderEnabled = total != 0.0
            if total != 0 {
                state.progressSliderValue = Float(currentTime / total)
            }

        case let .playerCurrentTrackChanged(currentTrack, playlist):
            switch playlist {
            case .none:
                state.albumCoverURL = nil
                state.title = Format.trackNoTitle
            case let .album(album):
                state.albumCoverURL = album.coverImageURL
                state.title = Format.trackFullTitle(currentTrack, album: album)
            }

        case let .progressSliderValueChanged(progress):
            if let total = state.totalTime {
                let cmd = AudioPlayerSystemCommand.seek(to: TimeInterval(progress) * total)
                state.effect = .init(.setPlayerCommands([cmd]))
            }

        case .playButtonTap:
            state.effect = .init(.setPlayerCommands([
                state.isPlaying ? .pause : .play
            ]))
        }
        return state
    }
}
