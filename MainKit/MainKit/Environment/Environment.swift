//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation
import Core


public protocol MusicAPIEnvironment {
    var musicAPI: MusicAPI { get }
}

public protocol AudioPlayerEnvironment {
    var audioPlayer: AudioPlayerSystem { get }
}
