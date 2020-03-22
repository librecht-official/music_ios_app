//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core


final class PlaybackProgressSlider: UIControl {
    let backgroundView = build(UIImageView()) { view in
        view.image = stylesheet().image.playbackProgressBackground
    }
    let remainingBackgroundView = build(UIView()) { view in
        view.backgroundColor = stylesheet().color.background.withAlphaComponent(0.65)
    }
    let runnerView = build(UIView()) { view in
        view.backgroundColor = UIColor.white
        view.layer.borderColor = stylesheet().color.lightGray1.cgColor
        view.layer.borderWidth = 1
    }
    
    /// [0.0 - 1.0]
    var value: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    fileprivate let valueDidChangeRelay = PublishRelay<CGFloat>()
    
    private var panValue: CGFloat = 0
    private var isInPanningState: Bool = false
    private var valueForDisplay: CGFloat {
        return isInPanningState ? panValue : value
    }
    
    private func commonInit() {
        addSubview(backgroundView)
        addSubview(remainingBackgroundView)
        addSubview(runnerView)
        backgroundView.clipsToBounds = true
        remainingBackgroundView.clipsToBounds = true
        runnerView.clipsToBounds = true
        
        backgroundView.layer.cornerRadius = k.height / 2
        remainingBackgroundView.layer.cornerRadius = k.height / 2
        runnerView.layer.cornerRadius = k.height / 2
        
        let panRecognizer = UIPanGestureRecognizer()
        panRecognizer.addTarget(self, action: #selector(handlePan))
        runnerView.addGestureRecognizer(panRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let runnerX = (bounds.width - k.height) * valueForDisplay
        let runnerFrame = CGRect(x: runnerX, y: 0, width: k.height, height: k.height)
        let remainingBackgroundViewFrame = CGRect(
            x: runnerX, y: 0,
            width: bounds.width - runnerX,
            height: k.height
        )
        remainingBackgroundView.frame = remainingBackgroundViewFrame
        backgroundView.frame = bounds
        runnerView.frame = runnerFrame
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: k.height)
    }
    
    private var runnerXAtPanBegining: CGFloat = 0
    @objc
    private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            runnerXAtPanBegining = runnerView.frame.minX
            isInPanningState = true
            
        case .changed:
            let translation = runnerXAtPanBegining + recognizer.translation(in: self).x
            panValue = min(1, max(0, translation / bounds.width))
            setNeedsLayout()
            
        case .ended:
            value = panValue
            valueDidChangeRelay.accept(panValue)
            isInPanningState = false
            
        default:
            isInPanningState = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Rx

extension Reactive where Base: PlaybackProgressSlider {
    var value: ControlProperty<Float> {
        let events = base.valueDidChangeRelay.map(Float.init)
        let binder = Binder<Float>(base) { (slider, value) in
            slider.value = CGFloat(value)
        }
        return ControlProperty<Float>(values: events, valueSink: binder)
    }
}

private enum k {
    static let height = CGFloat(28)
}
