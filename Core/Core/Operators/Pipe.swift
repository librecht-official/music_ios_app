//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

precedencegroup PipeForward {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator |> : PipeForward

public func |> <Value, Result>(value: Value, function: (Value) -> Result) -> Result {
    return function(value)
}

precedencegroup PipeBackward {
    associativity: right
    higherThan: LogicalConjunctionPrecedence
}

infix operator <| : PipeBackward

public func <| <Value, Result>(function: (Value) -> Result, value: Value) -> Result {
    return function(value)
}
