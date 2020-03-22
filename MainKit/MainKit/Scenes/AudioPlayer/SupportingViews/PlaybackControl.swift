//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Layout
import Core


final class PlaybackControl: UIView {
    private(set) lazy var playButton = UIButton(type: .custom)
    private(set) lazy var fastForwardButton = UIButton(type: .system)
    private(set) lazy var fastBackwardButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(fastBackwardButton)
        addSubview(playButton)
        addSubview(fastForwardButton)
    }
    
    // MARK: Layout
    
    private lazy var layout = Row(spacing: 4, [
        RowItem.fixed(width: .weight(1), Component(fastBackwardButton)),
        RowItem.fixed(width: .weight(1), Component(playButton)),
        RowItem.fixed(width: .weight(1), Component(fastForwardButton))
    ])
    
    override func layoutSubviews() {
        stylesheet().button.play(playButton)
        stylesheet().button.fastForward(fastForwardButton)
        stylesheet().button.fastBackward(fastBackwardButton)
        playButton.imageView?.contentMode = .scaleAspectFit
        fastForwardButton.imageView?.contentMode = .scaleAspectFit
        fastBackwardButton.imageView?.contentMode = .scaleAspectFit
        super.layoutSubviews()
        layout.performLayout(inFrame: bounds)
    }
}

// MARK: - Rx

extension Reactive where Base: PlaybackControl {
    var isEnabled: Binder<Bool> {
        return Binder(self.base) { (view, value) in
            view.playButton.isEnabled = value
            view.fastForwardButton.isEnabled = value
            view.fastBackwardButton.isEnabled = value
        }
    }
}
