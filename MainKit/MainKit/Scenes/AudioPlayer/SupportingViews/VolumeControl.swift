//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import MediaPlayer
import Layout
import Core

final class VolumeControl: UIView {
    private(set) lazy var volumeSlider: MPVolumeView = SystemVolumeView()
    private(set) lazy var minVolumeImageView = UIImageView()
    private(set) lazy var maxVolumeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(minVolumeImageView)
        addSubview(volumeSlider)
        addSubview(maxVolumeImageView)
    }
    
    // MARK: Layout
    
    private func makeLayout() -> LayoutComponent {
        let minVolSize = minVolumeImageView.image?.size ?? .zero
        let maxVolSize = maxVolumeImageView.image?.size ?? .zero
        
        return Row(
            spacing: 4, [
                RowItem.fixed(width: .abs(minVolSize.width),
                    Component(
                        minVolumeImageView,
                        .zero, .v4(centerY: .abs(0), height: .abs(minVolSize.height))
                    )
                ),
                RowItem.fixed(width: .weight(1), Component(volumeSlider)),
                RowItem.fixed(width:.abs(maxVolSize.width),
                    Component(
                        maxVolumeImageView,
                        .zero, .v4(centerY: .abs(0), height: .abs(maxVolSize.height))
                    )
                )
            ]
        )
    }
    
    override func layoutSubviews() {
        minVolumeImageView.image = stylesheet().image.minVolume
        maxVolumeImageView.image = stylesheet().image.maxVolume
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
