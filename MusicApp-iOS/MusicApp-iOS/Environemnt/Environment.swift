//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Core
import MainKit


final class AppEnvironment {
    let musicAPI: MusicAPI
    let audioPlayer: AudioPlayerSystem
    
    init() {
        self.audioPlayer = AppAudioPlayerSystem()
        self.musicAPI = MusicAPINetworkingClient(
            config: .init(
                baseURL: URL(string: "http://192.168.0.3:8000")!,
                logger: { print($0) }
            )
        )
    }
}

extension AppEnvironment: AudioPlayerEnvironment {}
extension AppEnvironment: MusicAPIEnvironment {}
