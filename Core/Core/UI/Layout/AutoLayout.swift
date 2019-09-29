//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


/// Just a small syntactic sugar over Anchor-based NSLayoutConstraint API
public enum AutoLayout {
    public enum YAxisAnchor {
        case top
        case bottom
        case centerY
        
        func anchor(_ view: UIView) -> NSLayoutYAxisAnchor {
            switch self {
            case .top:
                return view.topAnchor
            case .bottom:
                return view.bottomAnchor
            case .centerY:
                return view.centerYAnchor
            }
        }
    }
    
    @discardableResult
    public static func constrain(
        _ v1: UIView, _ anchor1: YAxisAnchor,
        with v2: UIView, _ anchor2: YAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        
        v1.translatesAutoresizingMaskIntoConstraints = false
        v2.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = anchor1.anchor(v1)
        let a2 = anchor2.anchor(v2)
        
        let result = a1.constraint(equalTo: a2, constant: constant)
        result.isActive = true
        
        return result
    }
    
    public enum XAxisAnchor {
        case leading
        case trailing
        case centerX
        
        func anchor(_ view: UIView) -> NSLayoutXAxisAnchor {
            switch self {
            case .leading:
                return view.leadingAnchor
            case .trailing:
                return view.trailingAnchor
            case .centerX:
                return view.centerXAnchor
            }
        }
    }
    
    @discardableResult
    public static func constrain(
        _ v1: UIView, _ anchor1: XAxisAnchor,
        with v2: UIView, _ anchor2: XAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        
        v1.translatesAutoresizingMaskIntoConstraints = false
        v2.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = anchor1.anchor(v1)
        let a2 = anchor2.anchor(v2)
        
        let result = a1.constraint(equalTo: a2, constant: constant)
        result.isActive = true
        
        return result
    }
    
    public enum AbsoluteSizeAnchor {
        case height(CGFloat)
        case width(CGFloat)
    }
    
    @discardableResult
    public static func constrain(_ v1: UIView, _ size: AbsoluteSizeAnchor) -> NSLayoutConstraint {
        v1.translatesAutoresizingMaskIntoConstraints = false
        
        let result: NSLayoutConstraint
        switch size {
        case let .height(h):
            result = v1.heightAnchor.constraint(equalToConstant: h)
        case let .width(w):
            result = v1.widthAnchor.constraint(equalToConstant: w)
        }
        result.isActive = true
        return result
    }
    
    public enum EqualSizeAnchor {
        case height
        case width
    }
    @discardableResult
    public static func constrain(
        _ v1: UIView, _ anchor1: EqualSizeAnchor,
        with v2: UIView, _ anchor2: EqualSizeAnchor) -> NSLayoutConstraint {
        
        v1.translatesAutoresizingMaskIntoConstraints = false
        v2.translatesAutoresizingMaskIntoConstraints = false
        
        let result: NSLayoutConstraint
        switch (anchor1, anchor2) {
        case (.height, .height):
            result = v1.heightAnchor.constraint(equalTo: v2.heightAnchor)
        case (.height, .width):
            result = v1.heightAnchor.constraint(equalTo: v2.widthAnchor)
        case (.width, .height):
            result = v1.widthAnchor.constraint(equalTo: v2.heightAnchor)
        case (.width, .width):
            result = v1.widthAnchor.constraint(equalTo: v2.widthAnchor)
        }
        result.isActive = true
        return result
    }
    
    public enum EqualityAnchor {
        case top(CGFloat)
        case bottom(CGFloat)
        case leading(CGFloat)
        case trailing(CGFloat)
        
        case safeAreaTop(CGFloat)
        case safeAreaBottom(CGFloat)
        case safeAreaLeading(CGFloat)
        case safeAreaTrailing(CGFloat)
        
        case height(multiplier: CGFloat)
        case width(multiplier: CGFloat)
    }
    
    @discardableResult
    public static func constrain(
        _ v1: UIView, with v2: UIView, _ anchors: [EqualityAnchor]) -> [NSLayoutConstraint] {
        
        v1.translatesAutoresizingMaskIntoConstraints = false
        v2.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        for anchor in anchors {
            let result: NSLayoutConstraint
            switch anchor {
            case let .top(c):
                result = v1.topAnchor.constraint(equalTo: v2.topAnchor, constant: c)
            case let .bottom(c):
                result = v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor, constant: c)
            case let .leading(c):
                result = v1.leadingAnchor.constraint(equalTo: v2.leadingAnchor, constant: c)
            case let .trailing(c):
                result = v1.trailingAnchor.constraint(equalTo: v2.trailingAnchor, constant: c)
                
            case let .safeAreaTop(c):
                result = v1.safeAreaLayoutGuide.topAnchor
                    .constraint(equalTo: v2.topAnchor, constant: c)
            case let .safeAreaBottom(c):
                result = v1.safeAreaLayoutGuide.bottomAnchor
                    .constraint(equalTo: v2.bottomAnchor, constant: c)
            case let .safeAreaLeading(c):
                result = v1.safeAreaLayoutGuide.leadingAnchor
                    .constraint(equalTo: v2.leadingAnchor, constant: c)
            case let .safeAreaTrailing(c):
                result = v1.safeAreaLayoutGuide.trailingAnchor
                    .constraint(equalTo: v2.trailingAnchor, constant: c)
                
            case let .height(m):
                result = v1.heightAnchor.constraint(equalTo: v2.heightAnchor, multiplier: m)
            case let .width(m):
                result = v1.widthAnchor.constraint(equalTo: v2.widthAnchor, multiplier: m)
            }
            result.isActive = true
            constraints.append(result)
        }
        return constraints
    }
    
    @discardableResult
    public static func pin(_ v1: UIView, to v2: UIView, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        constrain(v1, with: v2, [.top(0), .bottom(0), .leading(0), .trailing(0)])
    }
}
