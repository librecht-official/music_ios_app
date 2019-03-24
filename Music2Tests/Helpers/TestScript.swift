//
//  TestScript.swift
//  Music2Tests
//
//  Created by Vladislav Librecht on 03.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

class TestScript<State, Command> {
    typealias Reducer = (State, Command) -> State
    typealias Assertions = (_ newState: State, _ previousStates: [State]) -> Void
    
    var states = [State]()
    var currentState: State
    let reduce: (State, Command) -> State
    
    init(_ initialState: State, reduce: @escaping Reducer, firstCheck: Assertions) {
        self.currentState = initialState
        self.reduce = reduce
        check(state: initialState, assertions: firstCheck)
    }
    
    @discardableResult
    func when(_ command: Command, then assertions: Assertions) -> TestScript<State, Command> {
        currentState = reduce(currentState, command)
        check(state: currentState, assertions: assertions)
        return self
    }
    
    private func check(state: State, assertions: Assertions) {
        assertions(state, states)
        states.append(state)
    }
}
