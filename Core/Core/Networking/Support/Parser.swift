//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
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


