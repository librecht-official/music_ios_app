//
//  AudioPlayer.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

//protocol PlaylistIterator {
//    // Async?
//    func next() -> MusicTrack?
//    func previous() -> MusicTrack?
//}

enum Functional {
enum AudioPlayer {
    
    struct State: Transformable, Equatable {
        enum Playback {
            case playing, paused, stopped
        }
        var playlist: [MusicTrack]
        var currentTrackIndex: Int
        var playback: Playback
        
        var currentTrack: MusicTrack? {
            return playlist.element(at: currentTrackIndex)
        }
        
        enum NextAction: Equatable {
            case playNewItem(MusicTrack)
            case playCurrentItem
            case pauseCurrentItem
            case seek(to: TimeInterval)
        }
        var nextAction: NextAction?
    }
    
    enum Command {
        case setPlaylist([MusicTrack])
        case playTrackAtIndex(Int)
        case pause
        case resume
        case playingItemFinished
        
        // fastForward, fastBackward
//        case seek(to: TimeInterval)
//        case didSeek(to: TimeInterval)
    }
    
    static let initialState = State(
        playlist: [],
        currentTrackIndex: 0,
        playback: .stopped,
        nextAction: nil
    )
    
    static func reduce(state: State, command: Command) -> State {
        return state.transforming { newState in
            switch command {
            case .setPlaylist(let tracks):
                newState.playback = .stopped
                newState.playlist = tracks
                newState.currentTrackIndex = 0
                newState.nextAction = nil
            case .playTrackAtIndex(let index):
                if let (actualIndex, item) = newState.playlist.nextPlayableElement(startingFrom: index) {
                    newState.currentTrackIndex = actualIndex
                    newState.playback = .playing
                    newState.nextAction = .playNewItem(item)
                } else {
                    newState.nextAction = nil
                }
            case .pause:
                if newState.playback == .playing {
                    newState.playback = .paused
                    newState.nextAction = .pauseCurrentItem
                } else {
                    newState.nextAction = nil
                }
            case .resume:
                if newState.playback != .playing {
                    newState.playback = .playing
                    newState.nextAction = .playCurrentItem
                } else {
                    newState.nextAction = nil
                }
            case .playingItemFinished:
                let i = newState.currentTrackIndex + 1
                if let (nextIndex, nextItem) = newState.playlist.nextPlayableElement(startingFrom: i) {
                    newState.currentTrackIndex = nextIndex
                    newState.nextAction = .playNewItem(nextItem)
                } else {
                    newState.playback = .stopped
                }
                newState.nextAction = nil
                
//            case .seek(to: let time):
//                newState.nextAction = .seek(to: time)
//            case .didSeek(to: _):
//                newState.nextAction = nil
            }
        }
    }
}
}
