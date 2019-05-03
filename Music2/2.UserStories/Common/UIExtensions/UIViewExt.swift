//
//  UIViewExt.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

extension UIView {
    @available(*, deprecated)
    func constrain(
        subview: UIView, insets: UIEdgeInsets = .zero, topAnchor: NSLayoutYAxisAnchor? = nil) {
        
        if subview.superview != self {
            subview.removeFromSuperview()
            addSubview(subview)
        }
        subview.translatesAutoresizingMaskIntoConstraints = false
        let top = topAnchor ?? self.topAnchor
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: top, constant: insets.top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
        ])
    }
}

// MARK: - Factory functions

func infiniteScrollingIndicator() -> UIActivityIndicatorView {
    let i = UIActivityIndicatorView(style: .white)
    i.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    i.hidesWhenStopped = true
    return i
}

func loadingIndicator() -> UIActivityIndicatorView {
    let i = UIActivityIndicatorView(style: .gray)
    i.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    i.hidesWhenStopped = true
    return i
}
