//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


extension UIFont {
    static func scaled(_ weight: UIFont.Weight, _ size: CGFloat) -> UIFont {
        let original = UIFont.systemFont(ofSize: size, weight: weight)
        return UIFontMetrics.default.scaledFont(for: original)
    }
    
    static func scaled(_ weight: UIFont.Weight, _ size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        let original = UIFont.systemFont(ofSize: size, weight: weight)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: original)
    }
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        if let descriptor = fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: descriptor, size: 0) // size 0 means keep the size as it is
        }
        return self
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
