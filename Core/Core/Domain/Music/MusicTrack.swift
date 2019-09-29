//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


public struct MusicTrack: Equatable, Codable {
    public let id: Int
    public let title: String
    public let durationSec: TimeInterval
    public let albumsIds: [Int]
    public let audioURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, title, durationSec
        case albumsIds = "albums"
        case audioURL = "audio"
    }
    
    public var isAudioAvailable: Bool {
        return audioURL != nil
    }
}

public struct PlayableMusicTrack: Equatable {
    public let originalTrack: MusicTrack
    public let audioURL: URL
}

// MARK: - [MusicTrack]

public extension Array where Element == MusicTrack {
    func nextPlayableElement(startingFrom index: Int) -> (Int, PlayableMusicTrack)? {
        return enumerated()
            .first { (i, track) -> Bool in
                return i >= index && track.audioURL != nil
            }
            .map { (i, track) in
                return (i, PlayableMusicTrack(originalTrack: track, audioURL: track.audioURL!))
            }
    }
}
