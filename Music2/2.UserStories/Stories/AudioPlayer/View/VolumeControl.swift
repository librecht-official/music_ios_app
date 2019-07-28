//
//  VolumeControl.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import MediaPlayer
import Layout

final class VolumeControl: UIView {
    // MARK: Style
    
    struct Style {
        let sliderTintColor = Color.black
        let volumeIconsTintColor = Color.gray
        let minVolumeIcon = Asset.minVolume20x16
        let maxVolumeIcon = Asset.maxVolume20x16
    }
    var style = Style() { didSet { apply(style: style) } }
    func apply(style: Style) {
        volumeSlider.tintColor = style.sliderTintColor.uiColor
        minVolumeImageView.tintColor = style.volumeIconsTintColor.uiColor
        maxVolumeImageView.tintColor = style.volumeIconsTintColor.uiColor
        minVolumeImageView.image = style.minVolumeIcon.image.template
        maxVolumeImageView.image = style.maxVolumeIcon.image.template
    }
    
    // MARK: Properties
    
    private(set) lazy var volumeSlider: MPVolumeView = SystemVolumeView()
    private(set) lazy var minVolumeImageView = UIImageView()
    private(set) lazy var maxVolumeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(minVolumeImageView)
        addSubview(volumeSlider)
        addSubview(maxVolumeImageView)
        apply(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func makeLayout() -> LayoutComponent {
        let minVolSize = minVolumeImageView.image?.size ?? .zero
        let maxVolSize = maxVolumeImageView.image?.size ?? .zero
        
        return Row(
            spacing: 4, [
                RowItem(
                    Component(
                        minVolumeImageView,
                        .zero, .v4(centerY: .abs(0), height: .abs(minVolSize.height))
                    ),
                    length: .abs(minVolSize.width)
                ),
                RowItem(Component(volumeSlider), length: .weight(1)),
                RowItem(
                    Component(
                        maxVolumeImageView,
                        .zero, .v4(centerY: .abs(0), height: .abs(maxVolSize.height))
                    ),
                    length: .abs(maxVolSize.width)
                )
            ]
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.width > 0 {
            makeLayout().performLayout(inFrame: bounds)
        }
    }
}

// MARK: - SystemVolumeView

private final class SystemVolumeView: MPVolumeView {
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.volumeSliderRect(forBounds: bounds)
        rect.origin.y = bounds.origin.y
        rect.size.height = bounds.height
        return rect
    }
}
