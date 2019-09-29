//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


public struct Album: Equatable, Codable {
    public let id: Int
    public let title: String
    public let artist: Artist
    public let coverImageURL: URL?
    public let tracks: [MusicTrack]
    
    enum CodingKeys: String, CodingKey {
        case id, title, artist, tracks
        case coverImageURL = "coverImage"
    }
}
