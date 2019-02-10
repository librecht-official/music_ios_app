//
//  AlbumTracks.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

struct AlbumTracksState: Transformable, Equatable {
    var album: Album
}

enum AlbumTracksCommand {
    
}

enum AlbumTracks {
    static func initialState(album: Album) -> AlbumTracksState {
        return AlbumTracksState(
            album: album
        )
    }
    
    static func reduce(state: AlbumTracksState, command: AlbumTracksCommand) -> AlbumTracksState {
        return state
    }
}
