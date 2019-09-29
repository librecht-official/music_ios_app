//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


public extension Array {
    func element(at index: Int) -> Element? {
        if 0..<count ~= index {
            return self[index]
        }
        return nil
    }
}
