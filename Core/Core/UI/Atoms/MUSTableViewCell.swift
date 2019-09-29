//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Reusable


open class MUSTableViewCell<View: UIView>: UITableViewCell, Reusable {
    public private(set) lazy var v: View = View.loadFromNib()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
