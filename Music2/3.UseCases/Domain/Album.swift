//
//  Album.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

struct Album: Equatable, Codable {
    let id: Int
    let title: String
    let artist: Artist
    let coverImageURL: URL?
    let tracks: [MusicTrack]
    
    enum CodingKeys: String, CodingKey {
        case id, title, artist, tracks
        case coverImageURL = "coverImage"
    }
}

struct Artist: Equatable, Codable {
    let id: Int
    let name: String
}

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
        return DateComponentsFormatter.trackDuration.string(from: durationSec) ?? "--:--"
    }
    
    var isAudioAvailable: Bool {
        return audioURL != nil
    }
}

extension DateComponentsFormatter {
    static var trackDuration: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute, .second]
        f.unitsStyle = .positional
        return f
    }()
}
