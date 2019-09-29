//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


open class MUSButton: UIButton {
    public struct StateStyle {
        public let alpha: CGFloat
        public let backgroundColor: UIColor?
        public let borderColor: UIColor?

        public init(
            alpha: CGFloat = 1,
            backgroundColor: UIColor? = nil,
            borderColor: UIColor? = nil) {
            
            self.alpha = alpha
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
        }
    }
    
    var preferredHeight: CGFloat?
    var cornerRadius: CornerRadius = .abs(0) {
        didSet { setNeedsLayout() }
    }
    
    var normalStateStyle: StateStyle? { didSet { applyStyleForCurrentState() } }
    var hightlightedStateStyle: StateStyle? { didSet { applyStyleForCurrentState() } }
    var disabledStateStyle: StateStyle? { didSet { applyStyleForCurrentState() } }
    var selectedStateStyle: StateStyle? { didSet { applyStyleForCurrentState() } }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(cornerRadius)
    }
    
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if let height = preferredHeight {
            size.height = height
        }
        return size
    }
    
    public override var isHighlighted: Bool {
        didSet {
            applyStyleForCurrentState()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            applyStyleForCurrentState()
        }
    }
    
    private func applyStyleForCurrentState() {
        switch state {
        case .normal: applyStateStyle(normalStateStyle)
        case .highlighted: applyStateStyle(hightlightedStateStyle)
        case .disabled: applyStateStyle(disabledStateStyle)
        case .selected: applyStateStyle(selectedStateStyle)
        default: break
        }
    }
    private func applyStateStyle(_ style: StateStyle?) {
        UIView.animate(withDuration: 0.1) {
            if let s = style {
                self.alpha = s.alpha
                self.layer.borderColor = s.borderColor?.cgColor
                self.backgroundColor = s.backgroundColor
            }
        }
    }
}
