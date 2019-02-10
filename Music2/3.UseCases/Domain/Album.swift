//
//  Album.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

struct Album: Equatable, Codable {
    let id: Int
    let title: String
    let artist: Artist
    let coverImageURL: URL?
}

struct Artist: Equatable, Codable {
    let id: Int
    let name: String
}
