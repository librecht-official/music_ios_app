//
//  Transformable.swift
//  Music2
//
//  Created by Vladislav Librecht on 20.01.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

public func transform<Value>(_ transformation: @escaping (inout Value) -> Void) -> (Value) -> Value {
    return {
        var value = $0
        transformation(&value)
        return value
    }
}

public protocol Transformable {
    func transforming(_ transformation: @escaping (inout Self) -> Void) -> Self
}

public extension Transformable {
    func transforming(_ transformation: @escaping (inout Self) -> Void) -> Self {
        return transform(transformation)(self)
    }
}

import RxSwift
import RxCocoa

public extension BehaviorRelay {
    func transformValue(_ transformation: @escaping (inout Element) -> Void) {
        var val = value
        transformation(&val)
        accept(val)
    }
}
