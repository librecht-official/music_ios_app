//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #endif
}

public func releasePrint(_ object: Any) {
    Swift.print(object)
}

public func releasePrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    Swift.print(items, separator: separator, terminator: terminator)
}
