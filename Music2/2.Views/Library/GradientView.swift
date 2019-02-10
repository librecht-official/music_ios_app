//
//  GradientView.swift
//  Music2
//
//  Created by Vladislav Librecht on 11.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

class GradientView: UIView {
    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    convenience init(top: UIColor, bottom: UIColor) {
        self.init(topToBottom: [top, bottom])
    }
    
    init(topToBottom: [UIColor]) {
        super.init(frame: .zero)
        self.gradientLayer.colors = topToBottom.map { $0.cgColor }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
