//
//  AutoLayout.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

/**
 Just a small syntactic sugar over Anchor-based NSLayoutConstraint API
 */
enum AutoLayout {
    enum YAxisAnchor {
        case top
        case bottom
    }
    
    @discardableResult
    static func constraint(
        _ v1: UIView, _ anchor1: YAxisAnchor,
        with v2: UIView, _ anchor2: YAxisAnchor, inset: CGFloat = 0) -> NSLayoutConstraint {
        
        let result: NSLayoutConstraint
        switch (anchor1, anchor2) {
        case (.top, .top):
            result = v1.topAnchor.constraint(equalTo: v2.topAnchor)
        case (.top, .bottom):
            result = v1.topAnchor.constraint(equalTo: v2.bottomAnchor)
        case (.bottom, .top):
            result = v1.bottomAnchor.constraint(equalTo: v2.topAnchor)
        case (.bottom, .bottom):
            result = v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor)
        }
        result.isActive = true
        return result
    }
    
    enum XAxisAnchor {
        case leading
        case trailing
    }
    
    @discardableResult
    static func constraint(
        _ v1: UIView, _ anchor1: XAxisAnchor,
        with v2: UIView, _ anchor2: XAxisAnchor, inset: CGFloat = 0) -> NSLayoutConstraint {
        
        let result: NSLayoutConstraint
        switch (anchor1, anchor2) {
        case (.leading, .leading):
            result = v1.leadingAnchor.constraint(equalTo: v2.leadingAnchor)
        case (.leading, .trailing):
            result = v1.leadingAnchor.constraint(equalTo: v2.trailingAnchor)
        case (.trailing, .leading):
            result = v1.trailingAnchor.constraint(equalTo: v2.leadingAnchor)
        case (.trailing, .trailing):
            result = v1.trailingAnchor.constraint(equalTo: v2.trailingAnchor)
        }
        result.isActive = true
        return result
    }
    
    enum AbsoluteSizeAnchor {
        case height(CGFloat)
        case width(CGFloat)
    }
    
    @discardableResult
    static func constraint(_ v1: UIView, _ size: AbsoluteSizeAnchor) -> NSLayoutConstraint {
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
    
    enum EqualSizeAnchor {
        case height
        case width
    }
    @discardableResult
    static func constraint(
        _ v1: UIView, _ anchor1: EqualSizeAnchor,
        with v2: UIView, _ anchor2: EqualSizeAnchor) -> NSLayoutConstraint {
        
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
    
    enum EqualityAnchor {
        case top
        case bottom
        case leading
        case trailing
        
        case topConst(CGFloat)
        case bottomConst(CGFloat)
        case leadingConst(CGFloat)
        case trailingConst(CGFloat)
        
        case height(multiplier: CGFloat)
        case width(multiplier: CGFloat)
    }
    
    @discardableResult
    static func constraints(
        _ v1: UIView, with v2: UIView, _ anchors: [EqualityAnchor]) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        for anchor in anchors {
            let result: NSLayoutConstraint
            switch anchor {
            case .top:
                result = v1.topAnchor.constraint(equalTo: v2.topAnchor)
            case .bottom:
                result = v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor)
            case .leading:
                result = v1.leadingAnchor.constraint(equalTo: v2.leadingAnchor)
            case .trailing:
                result = v1.trailingAnchor.constraint(equalTo: v2.trailingAnchor)
                
            case let .topConst(c):
                result = v1.topAnchor.constraint(equalTo: v2.topAnchor, constant: c)
            case let .bottomConst(c):
                result = v1.bottomAnchor.constraint(equalTo: v2.bottomAnchor, constant: c)
            case let .leadingConst(c):
                result = v1.leadingAnchor.constraint(equalTo: v2.leadingAnchor, constant: c)
            case let .trailingConst(c):
                result = v1.trailingAnchor.constraint(equalTo: v2.trailingAnchor, constant: c)
                
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
}
