//
//  AudioPlayerView.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Kingfisher

class AudioPlayerView: MView {
    private(set) lazy var coverImageView = UIImageView()
    private(set) lazy var titleLabel = UILabel()
    private(set) lazy var playbackControl = PlaybackControl()
    private(set) lazy var volumeControl = VolumeControl()
    
    override func prepareLayout() {
        stackVertically(spacing: 32, insets: UIEdgeInsets(top: 32, left: 16, bottom: 16, right: 16), [
            VStackItem(coverImageView, [.heightToContainerRatio(0.4), .centerX, .aspectRatio(1)]),
            VStackItem(titleLabel),
            VStackItem(playbackControl, [.height(64), .leading, .trailing]),
            VStackItem(volumeControl,  [.height(64), .leading, .trailing])
        ])
    }
    
    override func configureViews() {
        titleLabel.textAlignment = .center
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 8
        coverImageView.kf.setImage(with: URL(string: "http://192.168.0.4:8000/media/images/music_album_covers/MARUV_BLACK_WATER_LU52eNg.jpeg"))
    }
}
