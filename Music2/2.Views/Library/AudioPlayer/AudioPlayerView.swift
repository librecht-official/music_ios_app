//
//  AudioPlayerView.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Kingfisher
import YogaKit

class AudioPlayerView: LayoutView {
    private(set) lazy var coverImageView = UIImageView()
    private(set) lazy var playbackProgress = PlaybackProgress()
    private(set) lazy var titleLabel = UILabel()
    private(set) lazy var playbackControl = PlaybackControl()
    private(set) lazy var volumeControl = VolumeControl()
    
    convenience init() {
        self.init(frame: .zero)
        
        Layout.Composite(self, style: Styles.container, [
            Layout.Image(coverImageView, style: Styles.albumCover),
            Layout.Component(playbackProgress),
            Layout.Label(titleLabel, style: Styles.title),
            Layout.Component(playbackControl),
            Layout.Composite(UIView(), style: Styles.volumeContainer, [
                Layout.Component(volumeControl)
            ])
        ])
        .configureLayout()
    }
    
    func set(albumCoverURL url: URL?) {
        coverImageView.kf.setImage(with: url, placeholder: Asset.musicAlbumPlaceholder122x120.image)
    }
}

private extension Styles {
    static let container = Layout.Style<UIView>(layout: {
        $0.flexGrow = 1
        $0.flexDirection = .column
        $0.justifyContent = .spaceBetween
        $0.alignItems = .stretch
        $0.marginHorizontal = 16
        $0.marginBottom = 32
    })
    
    static let albumCover = Layout.Style<UIImageView>(layout: {
        $0.flexGrow = 3
        $0.aspectRatio = 1
        $0.alignSelf = .center
        $0.marginVertical = 32
    }) {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.tintColor = Color.gray.uiColor
        $0.image = Asset.musicAlbumPlaceholder122x120.image.withRenderingMode(.alwaysTemplate)
    }
    
    static let title = Layout.Style<UILabel>(layout: {
        $0.flexGrow = 1
        $0.margin = 8
        $0.marginBottom = 16
    }) {
        $0.text = Format.trackNoTitle
        $0.textAlignment = .center
    }
    
    static let volumeContainer = Layout.Style(layout: {
        $0.flexGrow = 1
        $0.marginTop = 32
        $0.justifyContent = .flexEnd
    })
}
