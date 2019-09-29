//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


open class MUSImageView: UIImageView {
    var cornerRadius: CornerRadius = .abs(0) {
        didSet { setNeedsLayout() }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(cornerRadius)
    }
}
