//
//  VolumeControl.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import MediaPlayer

final class VolumeControl: UIView {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let minVolSize = minVolumeImageView.image?.size ?? .zero
        let maxVolSize = maxVolumeImageView.image?.size ?? .zero
        var minVolume = CGRect.zero
        var maxVolume = CGRect.zero
        stackRow(
            alignment: .fill, spacing: 4, [
                StackItem({ minVolume = $0 }, length: .abs(minVolSize.width)),
                StackItem({ self.volumeSlider.frame = $0 }, length: .weight(1)),
                StackItem({ maxVolume = $0 }, length: .abs(maxVolSize.width)),
            ],
            inFrame: bounds
        )
        self.minVolumeImageView.frame = layout(
            LayoutRules(
                h: .h1(leading: 0, trailing: 0),
                v: .v4(centerY: .abs(0), height: .abs(minVolSize.height))
            ),
            inFrame: minVolume
        )
        self.maxVolumeImageView.frame = layout(
            LayoutRules(
                h: .h1(leading: 0, trailing: 0),
                v: .v4(centerY: .abs(0), height: .abs(maxVolSize.height))
            ),
            inFrame: maxVolume
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
