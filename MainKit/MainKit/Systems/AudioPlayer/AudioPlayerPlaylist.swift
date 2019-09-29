//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Core


public enum AudioPlayerPlaylist: Equatable {
    case none
    case album(Album)
    
    public var tracks: [MusicTrack] {
        switch self {
        case .none:
            return []
        case let .album(album):
            return album.tracks
        }
    }
    
    public func nextPlayableElement(startingFrom index: Int) -> (Int, PlayableMusicTrack)? {
        return tracks.nextPlayableElement(startingFrom: index)
    }
}
