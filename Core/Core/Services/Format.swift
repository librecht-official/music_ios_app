//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


public enum Format {
    public static func trackFullTitle(_ track: MusicTrack?, album: Album?) -> String {
        guard let track = track else {
            return trackNoTitle
        }
        guard let album = album else {
            return track.title
        }
        return "\(album.artist.name) - \(track.title)"
    }
    
    public static let trackNoTitle = "--"
    
    public static func trackDuration(_ time: TimeInterval?) -> String {
        return time.flatMap {
            DateComponentsFormatter.trackDuration.string(from: $0)
            } ?? undefinedDuration
    }
    
    public static let undefinedDuration = "--:--"
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
