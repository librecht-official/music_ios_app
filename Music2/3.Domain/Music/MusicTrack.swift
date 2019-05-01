//
//  MusicTrack.swift
//  Music2
//
//  Created by Vladislav Librecht on 25.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

struct MusicTrack: Equatable, Codable {
    let id: Int
    let title: String
    let durationSec: TimeInterval
    let albumsIds: [Int]
    let audioURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, title, durationSec
        case albumsIds = "albums"
        case audioURL = "audio"
    }
    
    var duration: String {
        return Format.trackDuration(durationSec)
    }
    
    var isAudioAvailable: Bool {
        return audioURL != nil
    }
}

// MARK: - [MusicTrack]

extension Array where Element == MusicTrack {
    func nextPlayableElement(startingFrom index: Int) -> (Int, MusicTrack)? {
        return enumerated().first { (i, e) -> Bool in
            return i >= index && e.audioURL != nil
        }
    }
}
