//
//  VolumeControl.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import MediaPlayer
import YogaKit

class VolumeControl: LayoutComponent {
    private(set) lazy var volumeSlider: MPVolumeView = SystemVolumeView()
    private(set) lazy var minVolumeImageView = UIImageView()
    private(set) lazy var maxVolumeImageView = UIImageView()
    
    func render() -> LayoutNode {
        return Layout.Composite(UIView(), style: Styles.container, [
            Layout.Image(minVolumeImageView, style: Styles.image(Asset.minVolume20x16.image)),
            Layout.Leaf(volumeSlider, style: Styles.slider),
            Layout.Image(maxVolumeImageView, style: Styles.image(Asset.maxVolume20x16.image))
        ])
    }
}

private extension Styles {
    static let container = Layout.Style<UIView>(layout: {
        $0.flexGrow = 1
        $0.flexShrink = 1
        $0.flexDirection = .row
        $0.justifyContent = .spaceBetween
        $0.alignItems = .center
    })
    
    static let slider = Layout.Style<UIView>(layout: {
        $0.flexShrink = 1
        $0.marginHorizontal = 4
    }) {
        $0.tintColor = Color.black.uiColor
    }
    
    static func image(_ image: UIImage) -> Layout.Style<UIImageView> {
        return Layout.Style<UIImageView>(layout: {
            $0.width = YGValue(image.size.width)
            $0.height = YGValue(image.size.height)
        }) {
            $0.tintColor = Color.gray.uiColor
            $0.image = image.withRenderingMode(.alwaysTemplate)
        }
    }
}

private final class SystemVolumeView: MPVolumeView {
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.volumeSliderRect(forBounds: bounds)
        rect.origin.y = bounds.origin.y
        rect.size.height = bounds.height
        return rect
    }
}
