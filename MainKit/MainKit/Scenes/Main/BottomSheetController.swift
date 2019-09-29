//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//
// https://developer.apple.com/videos/play/wwdc2017/230/

import UIKit


protocol BottomSheetControllerDelegate: AnyObject {
    func bottomSheetControllerAnimatingState(to state: BottomSheetController.State)
    func bottomSheetControllerAnimatingFirstKeyframeState(to state: BottomSheetController.State)
    func bottomSheetControllerAnimatingLastKeyframeState(to state: BottomSheetController.State)
}

final class BottomSheetController {
    enum State {
        case closed
        case open
        
        var opposite: State {
            switch self {
            case .open: return .closed
            case .closed: return .open
            }
        }
    }
    
    weak var delegate: BottomSheetControllerDelegate?
    
    public init(
        bottomSheet: UIView,
        container: UIView,
        bottomSheetMaxHeight: CGFloat,
        bottomSheetMinHeight: CGFloat) {
        
        self.bottomSheet = bottomSheet
        self.container = container
        self.bottomSheetOffset = bottomSheetMaxHeight - bottomSheetMinHeight
        self.bottomSheetMinHeight = bottomSheetMinHeight
    }
    
    func prepare() {
        prepareConstraints()
        bottomSheet.addGestureRecognizer(panRecognizer)
    }
    
    private let bottomSheet: UIView
    private let container: UIView
    private let bottomSheetOffset: CGFloat
    /// Minimum visible height of the bottom sheet
    var bottomSheetMinHeight: CGFloat {
        didSet {
            bottomSheetHeightConstraint?.constant = bottomSheetTotalHeight
        }
    }
    private var bottomSheetTotalHeight: CGFloat {
        return bottomSheetOffset + bottomSheetMinHeight
    }
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()
    
    private var bottomConstraint: NSLayoutConstraint!
    private var bottomSheetHeightConstraint: NSLayoutConstraint!
    private func prepareConstraints() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(overlayView)
        overlayView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(bottomSheet)
        bottomSheet.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        bottomSheet.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        bottomConstraint = bottomSheet.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottomSheetOffset)
        bottomConstraint.isActive = true
        bottomSheetHeightConstraint = bottomSheet.heightAnchor.constraint(equalToConstant: bottomSheetTotalHeight)
        bottomSheetHeightConstraint.isActive = true
    }
    
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handlePan(_:)))
        return recognizer
    }()
    
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }
        
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.overlayView.alpha = 0.5
            case .closed:
                self.bottomConstraint.constant = self.bottomSheetOffset
                self.overlayView.alpha = 0
            }
            // zero duration here means that keyframe animation will inherit duration of it's outer property animator
            UIView.animateKeyframes(withDuration: 0, delay: 0, options: [], animations: {
                self.delegate?.bottomSheetControllerAnimatingState(to: state)
                self.container.layoutIfNeeded()
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                    self.delegate?.bottomSheetControllerAnimatingFirstKeyframeState(to: state)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                    self.delegate?.bottomSheetControllerAnimatingLastKeyframeState(to: state)
                })
            })
        })
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
                self.delegate?.bottomSheetControllerAnimatingState(to: self.currentState)
                self.delegate?.bottomSheetControllerAnimatingFirstKeyframeState(to: self.currentState)
                self.delegate?.bottomSheetControllerAnimatingLastKeyframeState(to: self.currentState)
                self.container.layoutIfNeeded()
            case .end:
                self.currentState = state
            case .current:
                break
            @unknown default:
                break
            }
            
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.bottomSheetOffset
            }
            
            self.runningAnimators.removeAll()
        }
        
        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.25)
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            let translation = recognizer.translation(in: bottomSheet)
            var fraction = -translation.y / bottomSheetOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open {
                fraction *= -1
            }
            if runningAnimators[0].isReversed {
                fraction *= -1
            }
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
        case .ended:
            let yVelocity = recognizer.velocity(in: bottomSheet).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                continueAllAnimations()
                break
            }
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
                if shouldClose && runningAnimators[0].isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
                if !shouldClose && runningAnimators[0].isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
            }
            continueAllAnimations()
        default:
            break
        }
    }
    
    private func continueAllAnimations() {
        runningAnimators.forEach {
            $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

