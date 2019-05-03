//
//  Printing.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #endif
}

func releasePrint(_ object: Any) {
    Swift.print(object)
}

func releasePrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    Swift.print(items, separator: separator, terminator: terminator)
}
