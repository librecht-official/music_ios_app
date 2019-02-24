//
//  UIView+.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

// MARK: - Layout DSL

enum StackItemLayoutRule {
    case height(CGFloat)
    case heightToContainerRatio(CGFloat)
    case width(CGFloat)
    case widthToContainerRatio(CGFloat)
    case aspectRatio(CGFloat)
    
    case centerX
    case centerXOffset(CGFloat)
    case centerY
    case centerYOffset(CGFloat)
    
    case top
    case leading
    case trailing
    case bottom
    
    case topInset(CGFloat)
    case leadingInset(CGFloat)
    case trailingInset(CGFloat)
    case bottomInset(CGFloat)
}

protocol StackItem {
    var view: UIView { get }
    var rules: [StackItemLayoutRule] { get }
}

struct VStackItem: StackItem {
    let view: UIView
    let rules: [StackItemLayoutRule]
    
    init(_ view: UIView, _ rules: [StackItemLayoutRule]? = nil) {
        self.view = view
        self.rules = rules ?? [.leading, .trailing]
    }
}

struct HStackItem: StackItem {
    let view: UIView
    let rules: [StackItemLayoutRule]
    
    init(_ view: UIView, _ rules: [StackItemLayoutRule]? = nil) {
        self.view = view
        self.rules = rules ?? [.top, .bottom]
    }
}

extension UIView {
    func constrain(subview: UIView, insets: UIEdgeInsets = .zero) {
        if subview.superview == nil {
            addSubview(subview)
        }
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            ])
    }
    
    func stackVertically(spacing: CGFloat, insets: UIEdgeInsets = .zero, _ items: [VStackItem]) {
        stack(
            spacing: spacing,
            insets: insets,
            items: items,
            extractLeadingAnchor: { $0.topAnchor },
            initialLeadingAnchorOffset: insets.top,
            extractTrailingAnchor: { $0.bottomAnchor },
            finalTrailingAnchorOffset: -insets.bottom
        )
    }
    
    func stackHorizontally(spacing: CGFloat, insets: UIEdgeInsets = .zero, _ items: [HStackItem]) {
        stack(
            spacing: spacing,
            insets: insets,
            items: items,
            extractLeadingAnchor: { $0.leadingAnchor },
            initialLeadingAnchorOffset: insets.left,
            extractTrailingAnchor: { $0.trailingAnchor },
            finalTrailingAnchorOffset: -insets.right
        )
    }
    
    func stack<AnchorType>(
        spacing: CGFloat,
        insets: UIEdgeInsets = .zero,
        items: [StackItem],
        extractLeadingAnchor: (UIView) -> NSLayoutAnchor<AnchorType>,
        initialLeadingAnchorOffset: CGFloat,
        extractTrailingAnchor: (UIView) -> NSLayoutAnchor<AnchorType>,
        finalTrailingAnchorOffset: CGFloat
        ) {
        if items.isEmpty {
            return
        }
        var constraints = [NSLayoutConstraint]()
        var currentLeadingAnchor = extractLeadingAnchor(self)
        var currentLeadingAnchorOffset = initialLeadingAnchorOffset
        
        for item in items {
            let (view, rules) = (item.view, item.rules)
            if view.superview == nil {
                addSubview(view)
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: [
                extractLeadingAnchor(view).constraint(equalTo: currentLeadingAnchor, constant: currentLeadingAnchorOffset),
            ])
            constraints.append(contentsOf: rules.map { constraint(rule: $0, item: view, insets: insets) })
            
            currentLeadingAnchor = extractTrailingAnchor(view)
            currentLeadingAnchorOffset = spacing
        }
        
        let hisAnchor = extractTrailingAnchor(items.last!.view)
        let myAnchor = extractTrailingAnchor(self)
        constraints.append(
            hisAnchor.constraint(equalTo: myAnchor, constant: finalTrailingAnchorOffset)
        )
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constraint(rule: StackItemLayoutRule, item: UIView, insets: UIEdgeInsets) -> NSLayoutConstraint {
        switch rule {
        case .height(let h):
            return item.heightAnchor.constraint(equalToConstant: h)
        case .heightToContainerRatio(let ratio):
            return item.heightAnchor.constraint(equalTo: item.superview!.heightAnchor, multiplier: ratio)
        case .width(let w):
            return item.widthAnchor.constraint(equalToConstant: w)
        case .widthToContainerRatio(let ratio):
            return item.widthAnchor.constraint(equalTo: item.superview!.widthAnchor, multiplier: ratio)
        case .aspectRatio(let ratio):
            return item.heightAnchor.constraint(equalTo: item.widthAnchor, multiplier: ratio)
        
        case .centerX:
            return item.centerXAnchor.constraint(equalTo: item.superview!.centerXAnchor, constant: 0)
        case .centerXOffset(let cx):
            return item.centerXAnchor.constraint(equalTo: item.superview!.centerXAnchor, constant: cx)
        case .centerY:
            return item.centerYAnchor.constraint(equalTo: item.superview!.centerYAnchor, constant: 0)
        case .centerYOffset(let cy):
            return item.centerYAnchor.constraint(equalTo: item.superview!.centerYAnchor, constant: cy)
            
        case .top:
            return item.topAnchor.constraint(equalTo: item.superview!.topAnchor, constant: insets.top)
        case .leading:
            return item.leadingAnchor.constraint(equalTo: item.superview!.leadingAnchor, constant: insets.left)
        case .trailing:
            return item.trailingAnchor.constraint(equalTo: item.superview!.trailingAnchor, constant: -insets.right)
        case .bottom:
            return item.bottomAnchor.constraint(equalTo: item.superview!.bottomAnchor, constant: -insets.bottom)
            
        case .topInset(let inset):
            return item.topAnchor.constraint(equalTo: item.superview!.topAnchor, constant: inset)
        case .leadingInset(let inset):
            return item.leadingAnchor.constraint(equalTo: item.superview!.leadingAnchor, constant: inset)
        case .trailingInset(let inset):
            return item.trailingAnchor.constraint(equalTo: item.superview!.trailingAnchor, constant: -inset)
        case .bottomInset(let inset):
            return item.bottomAnchor.constraint(equalTo: item.superview!.bottomAnchor, constant: -inset)
        }
    }
}

extension UIEdgeInsets {
    static let standard8 = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let standard16 = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}

// MARK: - Factory functions

func infiniteScrollingIndicator() -> UIActivityIndicatorView {
    let i = UIActivityIndicatorView(style: .white)
    i.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    i.hidesWhenStopped = true
    return i
}
