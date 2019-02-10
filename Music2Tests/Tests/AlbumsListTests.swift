//
//  AlbumsListTests.swift
//  Music2Tests
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
import Result
@testable import Music2

class AlbumsListTests: XCTestCase {
    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func testFetching() {
        let s0 = AlbumsList.initialState
        
        let s1 = AlbumsList.reduce(state: s0, command: .fetchMore)
        
        XCTAssert(s1.shouldLoadPage == true)
        XCTAssert(s1.nextFetchRequest == AlbumsListState.Request(offset: 0))
        XCTAssert(s1.shouldDisplayError == nil)
        
        let newAlbums = [Album.mock(id: 0), Album.mock(id: 1)]
        let s2 = AlbumsList.reduce(state: s1, command: .didFetchMore(NetworkingResult.success(newAlbums)))
        
        XCTAssert(s2.albums == newAlbums)
        XCTAssert(s2.shouldLoadPage == false)
        XCTAssert(s2.shouldDisplayError == nil)
        
        let error = AnyError(MockError())
        let s3 = AlbumsList.reduce(state: s2, command: .didFetchMore(.failure(error)))
        
        XCTAssert(s3.albums == newAlbums)
        XCTAssert(s3.shouldLoadPage == false)
        XCTAssert(s3.shouldDisplayError == error.localizedDescription)
    }
}
