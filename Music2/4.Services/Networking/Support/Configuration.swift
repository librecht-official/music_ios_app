//
//  Configuration.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

public struct Configuration {
    public let baseURL: URL
    public let headers = ["Content-type": "application/json"]
    public let decoder = JSONDecoder()
    public let encoder = JSONEncoder()
    
    public static let `default` = Configuration(baseURL: URL(string: "http://192.168.0.3:8000")!)
}
