//
//  DateComponentsFormatter+M.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

enum Format {
    static func trackFullTitle(_ track: MusicTrack?, album: Album?) -> String {
        guard let track = track else {
            return trackNoTitle
        }
        guard let album = album else {
            return track.title
        }
        return "\(album.artist.name) - \(track.title)"
    }
    
    static let trackNoTitle = "--"
    
    static func trackDuration(_ time: TimeInterval) -> String {
        return DateComponentsFormatter.trackDuration.string(from: time) ?? undefinedDuration
    }
    
    static let undefinedDuration = "--:--"
}

extension DateComponentsFormatter {
    static var trackDuration: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.unitsStyle = .positional
        f.zeroFormattingBehavior = .pad
        return f
    }()
}
