//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Core


struct TabTransition {
    let fromTabIndex: Int
    let targetTabIndex: Int
    let progress: CGFloat
}

final class TabsTopView: UIView {
    private lazy var highligtingView = UIView()
    private lazy var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        highligtingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(highligtingView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)
        AutoLayout.constrain(
            self, with: stackView, [.top(0), .leading(-20), .trailing(20), .bottom(0)]
        )
        self.translatesAutoresizingMaskIntoConstraints = false
        
        stylesheet().view.background(self)
        highligtingView.backgroundColor = stylesheet().color.primaryTint
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var content: [TabItem.TabKind] = [] {
        didSet {
            for c in content {
                switch c {
                case .title(let text):
                    let label = makeLabel()
                    label.text = text
                    stackView.addArrangedSubview(label)
                case .icon(let image):
                    let imageView = makeImageView()
                    imageView.image = image
                    stackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    private func makeLabel() -> UILabel {
        let label = MUSLabel()
        stylesheet().text.majorTitle3(label)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        AutoLayout.constrain(imageView, .height, with: imageView, .width)
        return imageView
    }
    
    func performTabTransition(_ transition: TabTransition) {
        let fromIndex = transition.fromTabIndex
        let targetIndex = transition.targetTabIndex
        guard 0 <= fromIndex && fromIndex < stackView.arrangedSubviews.count else { return }
        guard 0 <= targetIndex && targetIndex < stackView.arrangedSubviews.count else { return }
        
        let p = transition.progress
        if p != 0 {
            let fromView = stackView.arrangedSubviews[fromIndex]
            let toView = stackView.arrangedSubviews[targetIndex]
            let fromFrame = calcHighligtingViewFrame(
                rawFrame: fromView.frame, highligtingIndex: fromIndex
            )
            let toFrame = calcHighligtingViewFrame(
                rawFrame: toView.frame, highligtingIndex: targetIndex
            )
            let frame = fromFrame.interpolate(toFrame: toFrame, progress: p)
            setHighligtingView(frame: frame)
        }
        if p > 0.9 {
            updateLabels(highlighted: targetIndex)
        }
    }
    
    func set(highlightedViewIndex i: Int) {
        setNeedsLayout()
        layoutIfNeeded()
        let view = stackView.arrangedSubviews[i]
        let frame = calcHighligtingViewFrame(rawFrame: view.frame, highligtingIndex: i)
        setHighligtingView(frame: frame)
        updateLabels(highlighted: i)
    }
    
    private func setHighligtingView(frame: CGRect) {
        highligtingView.frame = frame
        highligtingView.layer.cornerRadius = highligtingView.frame.height / 2
    }
    
    private func calcHighligtingViewFrame(rawFrame: CGRect, highligtingIndex i: Int) -> CGRect {
        let inset: (dx: CGFloat, dy: CGFloat)
        switch content[i] {
        case .title: inset = (dx: -6, dy: -4)
        case .icon: inset = (dx: -2, dy: -2)
        }
        let rect = convert(rawFrame, from: stackView)
        return rect.insetBy(dx: inset.dx, dy: inset.dy)
    }
    
    private func updateLabels(highlighted: Int) {
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            if let label = view as? UILabel {
                label.textColor = i == highlighted ?
                    stylesheet().color.primaryWhiteText : stylesheet().color.primaryText
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
