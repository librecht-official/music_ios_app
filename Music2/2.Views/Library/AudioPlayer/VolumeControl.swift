//
//  VolumeControl.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import MediaPlayer

class VolumeControl: MView {
    private(set) lazy var volumeSlider = MPVolumeView()
    private(set) lazy var minVolumeImageView = UIImageView()
    private(set) lazy var maxVolumeImageView = UIImageView()
    
    override func prepareLayout() {
        stackHorizontally(spacing: 8, [
            HStackItem(minVolumeImageView, [.width(16)]),
            HStackItem(volumeSlider),
            HStackItem(maxVolumeImageView, [.width(16)]),
        ])
    }
    
    override func configureViews() {
        minVolumeImageView.image = Asset.minVolume20x16.image
        maxVolumeImageView.image = Asset.maxVolume20x16.image
        volumeSlider.tintColor = Color.black.uiColor
    }
}
