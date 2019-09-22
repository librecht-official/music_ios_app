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
    var nothingHere: Bool
    var sections: [ExploreSection]
    
    var shouldLoadPage: Bool
    var shouldDisplayError: String?
    
    var navigationRequest: ExploreNavigation.Route?
    
    var loadingRequest: Bool? { return shouldLoadPage ? true : nil }
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
        nothingHere: false,
        sections: [],
        shouldLoadPage: true,
        shouldDisplayError: nil,
        navigationRequest: nil
    )
    
    static func reduce(state: ExploreState, command: ExploreCommand) -> ExploreState {
        var newState = state
        switch command {
        case .reFetch:
            newState.shouldLoadPage = true
            newState.showLoading = newState.nothingHere
            newState.nothingHere = false
        case let .didFetch(.success(response)):
            newState.sections = buildSections(fromResponse: response)
            newState.shouldLoadPage = false
            newState.shouldDisplayError = nil
            newState.showLoading = false
            newState.nothingHere = newState.sections.allSatisfy { $0.items.isEmpty }
        case let .didFetch(.failure(error)):
            newState.shouldLoadPage = false
            newState.shouldDisplayError = error.localizedDescription
            newState.showLoading = false
            newState.nothingHere = state.sections.allSatisfy { $0.items.isEmpty }
        case let .didSelectAlbum(album):
            newState.navigationRequest = ExploreNavigation.Route.album(album)
        case .didOpenAlbum:
            newState.navigationRequest = nil
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
