//
//  NetworkingResult.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Moya
import Result

typealias NetworkingResult<T: Decodable> = Result<T, AnyError>

func parse<T: Decodable>(moyaResponse: Moya.Response) throws -> T {
    return try Configuration.default.decoder.decode(T.self, from: moyaResponse.data)
}
