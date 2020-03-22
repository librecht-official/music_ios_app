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

public func build<Value>(_ value: @autoclosure () -> Value, _ config: (inout Value) -> ()) -> Value {
    var val = value()
    config(&val)
    return val
}
