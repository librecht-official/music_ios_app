//
//  AudioPlayerLogic.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

enum AudioPlayer {
    // MARK: - State
    
    struct State: Equatable {
        enum Playback {
            case playing, paused, stopped
        }
        var playlist: AudioPlayerPlaylist
        var currentTrackIndex: Int
        var playback: Playback
        
        var currentTrack: MusicTrack? {
            return playlist.tracks.element(at: currentTrackIndex)
        }
        var currentItemIsSet: Bool
        
        enum NextAction: Equatable {
            case playNewItem(PlayableMusicTrack)
            case playCurrentItem
            case pauseCurrentItem
            case seek(to: TimeInterval)
        }
        var nextAction: NextAction?
    }
    
    // MARK: - Command
    
    enum Command {
        case setPlaylist(AudioPlayerPlaylist)
        case playTrackAtIndex(Int)
        case pause
        case resume
        case playingItemFinished
        
        // fastForward, fastBackward
        case seek(to: TimeInterval)
        case didSeek(to: TimeInterval)
        
        case currentItemIsSet(Bool)
    }
    
    // MARK: - Initial State
    
    static let initialState = State(
        playlist: .none,
        currentTrackIndex: 0,
        playback: .stopped,
        currentItemIsSet: false,
        nextAction: nil
    )
    
    // MARK: - Reduce
    
    static func reduce(state: State, command: Command) -> State {
        var newState = state
        switch command {
        case .setPlaylist(let playlist):
            newState.playback = .stopped
            newState.playlist = playlist
            newState.currentTrackIndex = 0
            newState.currentItemIsSet = false
            newState.nextAction = nil
        case .playTrackAtIndex(let index):
            let maybeNext = newState.playlist.nextPlayableElement(startingFrom: index)
            if let (actualIndex, item) = maybeNext {
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
            if newState.playback != .playing && newState.currentItemIsSet {
                newState.playback = .playing
                newState.nextAction = .playCurrentItem
            } else if newState.currentItemIsSet == false,
                let (nextIndex, nextItem) = newState.playlist
                    .nextPlayableElement(startingFrom: newState.currentTrackIndex) {
                newState.playback = .playing
                newState.currentTrackIndex = nextIndex
                newState.nextAction = .playNewItem(nextItem)
            } else {
                newState.nextAction = nil
            }
        case .playingItemFinished:
            let i = newState.currentTrackIndex + 1
            let maybeNext = newState.playlist.nextPlayableElement(startingFrom: i)
            if let (nextIndex, nextItem) = maybeNext {
                newState.currentTrackIndex = nextIndex
                newState.nextAction = .playNewItem(nextItem)
            } else {
                newState.playback = .stopped
                newState.nextAction = nil
            }
        case let .seek(to: time):
            newState.nextAction = .seek(to: time)
        case .didSeek(to: _):
            newState.nextAction = nil
        case let .currentItemIsSet(isSet):
            newState.currentItemIsSet = isSet
            newState.nextAction = nil
        }
        return newState
    }
}
