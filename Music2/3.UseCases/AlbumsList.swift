//
//  AlbumsList.swift
//  Music2
//
//  Created by Vladislav Librecht on 20.01.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import RxSwift
import Result

struct AlbumsListState: Transformable, Equatable {
    var albums: [Album]
    var shouldLoadPage: Bool
    var shouldDisplayError: String?
}

extension AlbumsListState {
    struct Request: Equatable {
        let offset: Int
    }
    var nextFetchRequest: Request? {
        return shouldLoadPage ? Request(offset: albums.count) : nil
    }
}

enum AlbumsListCommand {
    case fetchMore
    case didFetchMore(NetworkingResult<[Album]>)
}

enum AlbumsList {
    static let initialState = AlbumsListState(
        albums: [],
        shouldLoadPage: true,
        shouldDisplayError: nil
    )
    
    static func reduce(state: AlbumsListState, command: AlbumsListCommand) -> AlbumsListState {
        return state.transforming { newState in
            switch command {
            case .fetchMore:
                newState.shouldLoadPage = true
                newState.shouldDisplayError = nil
                
            case let .didFetchMore(.success(newAlbums)):
                newState.albums += newAlbums
                newState.shouldLoadPage = false
                newState.shouldDisplayError = nil
            
            case let .didFetchMore(.failure(error)):
                newState.shouldLoadPage = false
                newState.shouldDisplayError = error.localizedDescription
            }
        }
    }
}
