//
//  ModelMocks.swift
//  Music2Tests
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

@testable import Music2

extension Album {
    static func mock(id: Int) -> Album {
        return Album(
            id: id,
            title: "Title \(id)",
            artist: Artist(id: 1, name: "Artist \(id)"),
            coverImageURL: nil
        )
    }
}
