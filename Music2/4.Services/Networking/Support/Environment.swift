//
//  Environment.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

class Environment {
    private static var environments = [Environment]()
    
    class func push(_ environment: Environment) {
        environments.append(environment)
    }
    
    @discardableResult
    class func pop() -> Environment? {
        return environments.popLast()
    }
    
    class var current: Environment! {
        return environments.last
    }
    
    class func with(_ environment: Environment, do: () -> ()) {
        push(environment)
        `do`()
        pop()
    }
}

//class APIEnvironment: Environment {
//    let baseURL = URL(string: "http://127.0.0.1:8000/")!
//}
