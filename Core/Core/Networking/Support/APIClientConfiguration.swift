//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation

public struct APIClientConfiguration {
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
