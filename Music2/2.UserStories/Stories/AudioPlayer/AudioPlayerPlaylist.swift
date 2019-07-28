//
//  AudioPlayerPlaylist.swift
//  Music2
//
//  Created by Vladislav Librecht on 29/07/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

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
    
    func nextPlayableElement(startingFrom index: Int) -> (Int, PlayableMusicTrack)? {
        return tracks.nextPlayableElement(startingFrom: index)
    }
}
