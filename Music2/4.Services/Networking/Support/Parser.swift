//
//  Parser.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation
import Moya

public struct Parser {
    public let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    public func parse<T: Decodable>(moyaResponse: Moya.Response) throws -> T {
        return try decoder.decode(T.self, from: moyaResponse.data)
    }
}


