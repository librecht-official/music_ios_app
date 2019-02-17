//
//  AudioPlayer.swift
//  Music2
//
//  Created by Vladislav Librecht on 18.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AudioPlayerContractor: AnyObject {
    func set(tracks: [MusicTrack])
    func play(url: URL)
}

protocol AudioPlayer {
    var contractor: AudioPlayerContractor? { get set }
    func set(tracks: [MusicTrack])
    func play()
}

class AppAudioPlayer: AudioPlayer {
    weak var contractor: AudioPlayerContractor?
    
    private let tracks = BehaviorRelay<[MusicTrack]>(value: [])
//    var playingTrack: Observable<MusicTrack>
    
    func set(tracks: [MusicTrack]) {
        contractor?.set(tracks: tracks)
        self.tracks.accept(tracks)
    }
    
    func play() {
        if let next = self.tracks.value.first?.audioURL {
            contractor?.play(url: next)
        }
    }
    
    func pause() {
        
    }
}
