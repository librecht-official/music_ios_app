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
    private(set) lazy var playbackProgressView = PlaybackProgressView()
    private(set) lazy var titleLabel = UILabel()
    private(set) lazy var playbackControl = PlaybackControl()
    private(set) lazy var volumeControl = VolumeControl()
    
    override func prepareLayout() {
        stackVertically(spacing: 32, insets: UIEdgeInsets(top: 32, left: 16, bottom: 44, right: 16), [
            VStackItem(coverImageView, [.centerX, .aspectRatio(1)]),
            VStackItem(playbackProgressView, [.height(44), .leading, .trailing]),
            VStackItem(titleLabel, [.height(20), .leading, .trailing]),
            VStackItem(playbackControl, [.height(64), .leading, .trailing]),
            VStackItem(volumeControl,  [.height(38), .leading, .trailing])
        ])
    }
    
    override func configureViews() {
        titleLabel.text = Format.trackNoTitle
        titleLabel.textAlignment = .center
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 8
        coverImageView.image = Asset.musicAlbumPlaceholder122x120.image
    }
    
    func set(albumCoverURL url: URL?) {
        coverImageView.kf.setImage(with: url, placeholder: Asset.musicAlbumPlaceholder122x120.image)
    }
}
