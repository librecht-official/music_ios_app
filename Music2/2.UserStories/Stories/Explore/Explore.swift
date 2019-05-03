//
//  Explore.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Foundation

// MARK: - State

struct ExploreState: Transformable {
    var showLoading: Bool
    var sections: [ExploreSection]
    
    var shouldLoadPage: Bool
    var shouldDisplayError: String?
    var shouldOpenAlbum: Album?
    
    var loadingRequest: Void? { return shouldLoadPage ? () : nil }
}

struct ExploreSection: Equatable {
    let headerTitle: String
    var items: [ExploreItem]
}

enum ExploreItem: Equatable {
    case albumRow(Album)
    case albumCardsCollection([Album])
}

// MARK: - Command

enum ExploreCommand {
    case reFetch
    case didFetch(NetworkingResult<ExploreResponse>)
    case didSelectAlbum(Album)
    case didOpenAlbum
}

// MARK: - Module

enum Explore {
    static let initialState = ExploreState(
        showLoading: true,
        sections: [],
        shouldLoadPage: true,
        shouldDisplayError: nil,
        shouldOpenAlbum: nil
    )
    
    static func reduce(state: ExploreState, command: ExploreCommand) -> ExploreState {
        var newState = state
        switch command {
        case .reFetch:
            newState.shouldLoadPage = true
        case let .didFetch(.success(response)):
            newState.sections = buildSections(fromResponse: response)
            newState.shouldLoadPage = false
            newState.shouldDisplayError = nil
            newState.showLoading = false
        case let .didFetch(.failure(error)):
            newState.shouldLoadPage = false
            newState.shouldDisplayError = error.localizedDescription
            newState.showLoading = false
        case let .didSelectAlbum(album):
            newState.shouldOpenAlbum = album
        case .didOpenAlbum:
            newState.shouldOpenAlbum = nil
        }
        return newState
    }
    
    static func buildSections(fromResponse r: ExploreResponse) -> [ExploreSection] {
        return [
            ExploreSection(
                headerTitle: L10n.Explore.Section.recommendations,
                items: r.recommendations.map { ExploreItem.albumRow($0) }
            ),
            ExploreSection(
                headerTitle: L10n.Explore.Section.trending,
                items: [ExploreItem.albumCardsCollection(r.trending)]
            ),
            ExploreSection(
                headerTitle: L10n.Explore.Section.popular,
                items: r.popular.map { ExploreItem.albumRow($0) }
            )
        ]
    }
}

//ExploreState(
//    sections: [
//        ExploreSection(headerTitle: L10n.Explore.Section.recommendations, items: [
//            ExploreItem.albumRow(
//                Album(
//                    id: 1,
//                    title: "Title 1",
//                    artist: Artist(id: 1, name: "Artist 1"),
//                    coverImageURL: nil,
//                    tracks: []
//                )
//            ),
//            ExploreItem.albumRow(
//                Album(
//                    id: 2,
//                    title: "Black Water",
//                    artist: Artist(id: 1, name: "MARUV"),
//                    coverImageURL: URL(string: "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/jazz-dark-album-cover-template-966020e215ba3c34a2b5d68b2d386cd7.jpg"),
//                    tracks: []
//                )
//            ),
//            ]),
//        ExploreSection(headerTitle: L10n.Explore.Section.trending, items: [
//            ExploreItem.albumCardsCollection([
//                Album(
//                    id: 2,
//                    title: "Black Water",
//                    artist: Artist(id: 1, name: "MARUV"),
//                    coverImageURL: URL(string: "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/jazz-dark-album-cover-template-966020e215ba3c34a2b5d68b2d386cd7.jpg"),
//                    tracks: []
//                ),
//                Album(
//                    id: 2,
//                    title: "Born to Die",
//                    artist: Artist(id: 1, name: "LANA DEL REY"),
//                    coverImageURL: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Features/v4/4a/ef/6f/4aef6f53-650e-c936-6e52-42c6c277583e/dj.fbwsyszy.jpg/268x0w.jpg"),
//                    tracks: []
//                ),
//                Album(
//                    id: 2,
//                    title: "Black Water",
//                    artist: Artist(id: 1, name: "MARUV"),
//                    coverImageURL: nil,
//                    tracks: []
//                ),
//                Album(
//                    id: 2,
//                    title: "Black Water",
//                    artist: Artist(id: 1, name: "MARUV"),
//                    coverImageURL: URL(string: "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/jazz-dark-album-cover-template-966020e215ba3c34a2b5d68b2d386cd7.jpg"),
//                    tracks: []
//                )
//                ])
//            ]),
//        ExploreSection(headerTitle: "Popular", items: [
//            ExploreItem.mock1(), ExploreItem.mock2(), ExploreItem.mock1(),
//            ExploreItem.mock2(), ExploreItem.mock1(), ExploreItem.mock2(),
//            ExploreItem.mock1(), ExploreItem.mock2(), ExploreItem.mock1(),
//            ExploreItem.mock2(), ExploreItem.mock1(), ExploreItem.mock2()
//            ])
//    ]
//)
//
//extension ExploreItem {
//    static func mock1() -> ExploreItem {
//        return ExploreItem.albumRow(
//            Album(
//                id: 2,
//                title: "Black Water",
//                artist: Artist(id: 1, name: "MARUV"),
//                coverImageURL: URL(string: "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/jazz-dark-album-cover-template-966020e215ba3c34a2b5d68b2d386cd7.jpg"),
//                tracks: []
//            )
//        )
//    }
//    
//    static func mock2() -> ExploreItem {
//        return ExploreItem.albumRow(
//            Album(
//                id: 2,
//                title: "Born to Die",
//                artist: Artist(id: 1, name: "LANA DEL REY"),
//                coverImageURL: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Features/v4/4a/ef/6f/4aef6f53-650e-c936-6e52-42c6c277583e/dj.fbwsyszy.jpg/268x0w.jpg"),
//                tracks: []
//            )
//        )
//    }
//}
