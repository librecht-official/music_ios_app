//
//  Feedback.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

typealias CocoaFeedback<State, Command> = (Driver<State>) -> Signal<Command>

/// Special wrapper function to create navigation binding, allowing navigation by the same query more then once in a row
func navigationBinding<State, Query, Event>(
    request: @escaping (State) -> Query?,
    effects: @escaping (Query) -> Signal<Event>
    ) -> (Driver<State>) -> Signal<Event> {
    
    return react(request: { state -> NeverEqual<Query>? in
        request(state).map(NeverEqual.init)
    }) { neverEqual -> Signal<Event> in
        effects(neverEqual.value)
    }
}

private struct NeverEqual<T>: Equatable {
    let value: T
    init(_ value: T) {
        self.value = value
    }
    
    static func == (lhs: NeverEqual<T>, rhs: NeverEqual<T>) -> Bool {
        return false
    }
}
