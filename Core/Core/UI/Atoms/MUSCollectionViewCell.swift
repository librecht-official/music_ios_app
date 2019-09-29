//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Reusable


open class MUSCollectionViewCell<View: UIView>: UICollectionViewCell, Reusable {
    public private(set) lazy var v: View = View.loadFromNib()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(v)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(v)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        v.frame = contentView.bounds
    }
}
