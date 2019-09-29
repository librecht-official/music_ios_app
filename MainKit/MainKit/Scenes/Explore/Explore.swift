//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Core


public enum Explore {
    struct State {
        var showLoading: Bool = true
        var nothingHere: Bool = false
        var sections: [Section] = []
        var error: String? = nil
        
        var effect: Feedback.Request<Effect>? = .init(.fetchExploreSummary)
    }
    
    struct Section: Equatable {
        let headerTitle: String
        var items: [Item]
    }

    enum Item: Equatable {
        case albumRow(Album)
        case albumCardsCollection([Album])
    }
    
    enum Effect {
        case fetchExploreSummary
        case setPlayerCommands([AudioPlayerSystemCommand])
    }

    enum Command {
        case reFetch
        case didFetch(NetworkingResult<ExploreSummary>)
        case didSelectAlbum(Album)
        case playAlbum(Album)
    }
    
    static func reduce(state: State, command: Command) -> State {
        var state = state
        switch command {
        case .reFetch:
            state.effect = .init(.fetchExploreSummary)
            state.showLoading = state.nothingHere
            state.nothingHere = false
            
        case let .didFetch(.success(response)):
            state.sections = buildSections(fromResponse: response)
            state.error = nil
            state.showLoading = false
            state.nothingHere = state.sections.allSatisfy { $0.items.isEmpty }
            
        case let .didFetch(.failure(error)):
            state.error = error.localizedDescription
            state.showLoading = false
            state.nothingHere = state.sections.allSatisfy { $0.items.isEmpty }
            
        case let .didSelectAlbum(album): break
            
        case let .playAlbum(album):
            state.effect = .init(.setPlayerCommands([
                .setPlaylist(.album(album)),
                .play
            ]))
        }
        return state
    }
    
    static func buildSections(fromResponse r: ExploreSummary) -> [Section] {
        return [
            Section(
                headerTitle: L10n.Explore.Section.recommendations,
                items: r.recommendations.map { Item.albumRow($0) }
            ),
            Section(
                headerTitle: L10n.Explore.Section.trending,
                items: [Item.albumCardsCollection(r.trending)]
            ),
            Section(
                headerTitle: L10n.Explore.Section.popular,
                items: r.popular.map { Item.albumRow($0) }
            )
        ]
    }
}
