//
//  Explore.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

public struct ExploreResponse: Decodable {
    let recommendations: [Album]
    let trending: [Album]
    let popular: [Album]
}
