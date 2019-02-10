//
//  URLParametersConvertible.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

protocol URLParametersConvertible {
    var parameters: [String: Any] { get }
}

extension URLParametersConvertible {
    var parameters: [String: Any] {
        let keysAndValues = Mirror(reflecting: self).children
            .compactMap { (label, value) -> (String, Any)? in
                if case Optional<Any>.none = value {
                    return nil
                }
                return label.flatMap { ($0, value) }
        }
        return Dictionary(uniqueKeysWithValues: keysAndValues)
    }
}
