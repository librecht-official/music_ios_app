//
//  AlbumTracks.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

// MARK: - State

struct AlbumTracksState: Transformable, Equatable {
    var album: Album
    var shouldPlayTrack: MusicTrack?
}

// MARK: - Command

enum AlbumTracksCommand {
    case didSelectItem(at: Int)
    case didStartPlayingTrack
}

// MARK: - Module

enum AlbumTracks {
    static func initialState(album: Album) -> AlbumTracksState {
        return AlbumTracksState(
            album: album,
            shouldPlayTrack: nil
        )
    }
    
    static func reduce(state: AlbumTracksState, command: AlbumTracksCommand) -> AlbumTracksState {
        return state.transforming { newState in
            switch command {
            case let .didSelectItem(at: index):
                newState.shouldPlayTrack = state.album.tracks[index]
            case .didStartPlayingTrack:
                newState.shouldPlayTrack = nil
            }
        }
    }
}
