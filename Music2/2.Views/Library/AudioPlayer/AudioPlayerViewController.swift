//
//  AudioPlayerViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    private lazy var interfaceView = AudioPlayerView()
    
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Environment.current.audioPlayer.contractor = self
        
        view.addSubview(interfaceView)
        view.constrain(subview: interfaceView)
        
        interfaceView.playbackControl.playButton.addTarget(
            self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside
        )
    }
    
    @objc func playButtonTapped(_ sender: UIButton) {
        if player?.rate == 0 {
            player?.play()
            interfaceView.playbackControl.playButton.isSelected = true
        }
        else {
            player?.pause()
            interfaceView.playbackControl.playButton.isSelected = false
        }
    }
}

// MARK: - AudioPlayerContractor

extension AudioPlayerViewController: AudioPlayerContractor {
    func set(tracks: [MusicTrack]) {
        let track = tracks.first
        // TODO: Need Album here for cover and artist info
        interfaceView.titleLabel.text = track?.title
    }
    
    func play(url: URL) {
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}
