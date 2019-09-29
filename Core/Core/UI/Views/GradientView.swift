//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


public class GradientView: UIView {
    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public convenience init(top: UIColor, bottom: UIColor) {
        self.init(topToBottom: [top, bottom])
    }
    
    public init(topToBottom: [UIColor]) {
        super.init(frame: .zero)
        self.gradientLayer.colors = topToBottom.map { $0.cgColor }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
