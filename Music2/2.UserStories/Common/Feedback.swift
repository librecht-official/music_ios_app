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

/** Special wrapper function to create navigation binding, allowing navigation by the same query more then once in a row */
func navigationBinding<State, Query, Mutation>(
    query: @escaping (State) -> Query?,
    effects: @escaping (Query) -> Signal<Mutation>
    ) -> (Driver<State>) -> Signal<Mutation> {
    
    return react(query: query, areEqual: { (_, _) in false }, effects: effects)
}
