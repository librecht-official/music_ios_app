//
//  UIKit+Layout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 09.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

extension UIView: FrameHolder {}
extension CALayer: FrameHolder {}

extension UILabel: SizeAware {}
extension UIImageView: SizeAware {}
extension UITextField: HeightAware {
    public func size(ifWidth width: CGFloat) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
}
extension UITextView: SizeAware {}
extension UISlider: HeightAware {
    public func size(ifWidth width: CGFloat) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
}
extension UISearchBar: HeightAware {
    public func size(ifWidth width: CGFloat) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
}
