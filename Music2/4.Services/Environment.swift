//
//  Environment.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

class Environment {
    private static var environments = [Environment]()
    
    class func push(_ environment: Environment) {
        environments.append(environment)
    }
    
    @discardableResult
    class func pop() -> Environment? {
        return environments.popLast()
    }
    
    class var current: Environment! {
        return environments.last
    }
    
    class func with(_ environment: Environment, do: () -> ()) {
        push(environment)
        `do`()
        pop()
    }
    
    let audioPlayer: AudioPlayerSystem
    let api: NetworkingAPI
    
    init(audioPlayer: AudioPlayerSystem, api: NetworkingAPI) {
        self.audioPlayer = audioPlayer
        self.api = api
    }
}

func makeAppEnvironment() -> Environment {
    let audioPlayer = AppAudioPlayerSystem()
    
    return Environment(
        audioPlayer: audioPlayer,
        api: NetworkingAPI(
            music: MusicAPINetworkingClient(
                config: APIConfiguration(
                    baseURL: URL(string: "http://192.168.0.2:8000")!,
                    logger: { print($0) }
                )
            )
        )
    )
}

struct NetworkingAPI {
    let music: MusicAPI
}
