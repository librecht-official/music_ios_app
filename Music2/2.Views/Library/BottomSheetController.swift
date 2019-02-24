//
//  BottomSheetController.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

class BottomSheetController {
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
    private let bottomSheetMinHeight: CGFloat
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private var bottomConstraint: NSLayoutConstraint!
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
        bottomSheet.heightAnchor.constraint(equalToConstant: bottomSheetOffset + bottomSheetMinHeight).isActive = true
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
        recognizer.addTarget(self, action: #selector(bottomSheetPanned(recognizer:)))
        return recognizer
    }()
    
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.overlayView.alpha = 0.5
//                self.container.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                self.bottomSheet.transform = CGAffineTransform(scaleX: 1.0 / 0.9, y: 1.0 / 0.9)
//                self.closedTitleLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
//                self.openTitleLabel.transform = .identity
            case .closed:
                self.bottomConstraint.constant = self.bottomSheetOffset
                self.overlayView.alpha = 0
//                self.container.transform = .identity
//                self.bottomSheet.transform = .identity
//                self.closedTitleLabel.transform = .identity
//                self.openTitleLabel.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
            }
            self.container.layoutIfNeeded()
        })
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.bottomSheetOffset
            }
            
            self.runningAnimators.removeAll()
        }
        
        //        // an animator for the title that is transitioning into view
        //        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
        //            switch state {
        //            case .open:
        //                self.openTitleLabel.alpha = 1
        //            case .closed:
        //                self.closedTitleLabel.alpha = 1
        //            }
        //        })
        //        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        //        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
        //            switch state {
        //            case .open:
        //                self.closedTitleLabel.alpha = 0
        //            case .closed:
        //                self.openTitleLabel.alpha = 0
        //            }
        //        })
        //        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        //        inTitleAnimator.startAnimation()
        //        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        //        runningAnimators.append(inTitleAnimator)
        //        runningAnimators.append(outTitleAnimator)
    }
    
    @objc private func bottomSheetPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            let translation = recognizer.translation(in: bottomSheet)
            var fraction = -translation.y / bottomSheetOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            let yVelocity = recognizer.velocity(in: bottomSheet).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            break
        }
    }
}

