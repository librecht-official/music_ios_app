//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit

public extension UIView {
    class func loadFromNib() -> Self {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        return bundle.loadNibNamed(nibName, owner: nil)!.first! as! Self
    }
}
