//
//  AudioPlayerSystem.swift
//  Music2
//
//  Created by Vladislav Librecht on 04.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa
import RxFeedback

class AudioPlayerSystem {
    private typealias AudioPlayer = Functional.AudioPlayer
    private typealias State = AudioPlayer.State
    private typealias Command = AudioPlayer.Command
    private typealias Feedback = (Driver<State>) -> Signal<Command>
    
    private let player = AVPlayer(playerItem: nil)
    private let disposeBag = DisposeBag()
    
    init() {
        let bindAV: Feedback = bind(self) { (self, state) -> Bindings<Command> in
            let avToCommands = [
                self.player.rx.currentItemDidPlayToEnd.map { _ in Command.playingItemFinished }
            ]
            
            return Bindings(subscriptions: [], mutations: avToCommands)
        }
        
        let system = Driver.system(
            initialState: AudioPlayer.initialState,
            reduce: AudioPlayer.reduce,
            feedback: bindAV
        )
        system.drive().disposed(by: disposeBag)
    }
}
