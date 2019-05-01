//
//  ProgressSlider.swift
//  Music2
//
//  Created by Vladislav Librecht on 31.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import YogaKit

class ProgressSlider: LayoutComponent {
    private(set) lazy var slider: UISlider = Slider()
    private lazy var imageView = UIImageView()
    
    func render() -> LayoutNode {
        return Layout.Composite(UIView(), style: Styles.container, [
            Layout.Image(imageView, style: Styles.sliderBackground),
            Layout.Leaf(slider, style: Styles.slider),
        ])
    }
}

private extension Styles {
    static let container = Layout.Style<UIView>(layout: {
        $0.justifyContent = .center
        $0.alignItems = .stretch
    })
    
    static let sliderBackground = Layout.Style<UIImageView>(styling: {
        $0.image = Asset.progressBackground3.image
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    })
    
    static let slider = Layout.Style<UISlider>(layout: {
        $0.position = .absolute
        $0.top = 0
        $0.left = 0
        $0.right = 0
        $0.bottom = 0
        $0.alignSelf = .center
    }) {
        $0.setMinimumTrackImage(Asset.playedProgress.image, for: .normal)
        $0.setMaximumTrackImage(Asset.remaingingProgress3.image, for: .normal)
    }
}

private final class Slider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.size.height = 28
        return rect
    }
}
