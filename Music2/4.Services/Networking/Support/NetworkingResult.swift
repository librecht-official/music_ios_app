//
//  NetworkingResult.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation
import Result

typealias NetworkingResult<T: Decodable> = Result<T, AnyError>
