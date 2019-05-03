//
//  Configuration.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

public struct APIConfiguration {
    public typealias Headers = [String: String]
    public typealias Logging = (Any) -> ()
    
    public let baseURL: URL
    public let headers: Headers
    public let decoder: JSONDecoder
    public let encoder: JSONEncoder
    public let logger: Logging?
    
    public init(baseURL: URL,
         headers: Headers = ["Content-type": "application/json"],
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         logger: Logging?) {
        
        self.baseURL = baseURL
        self.headers = headers
        self.decoder = decoder
        self.encoder = encoder
        self.logger = logger
    }
}
