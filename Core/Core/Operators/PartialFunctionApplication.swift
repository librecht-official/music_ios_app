
//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

precedencegroup PartialFunctionApplication {
    associativity: left
    higherThan: BitwiseShiftPrecedence, PipeForward
}

infix operator § : PartialFunctionApplication

public func § <Arg0, Arg1, Result>(
    _ function: @escaping (Arg0, Arg1) -> Result,
    _ arg0: Arg0) -> (Arg1) -> Result {
    return { function(arg0, $0) }
}

public func § <Arg0, Arg1, Arg2, Result>(
    _ function: @escaping (Arg0, Arg1, Arg2) -> Result,
    _ arg0: Arg0) -> (Arg1, Arg2) -> Result {
    return { function(arg0, $0, $1) }
}

public func § <Arg0, Arg1, Arg2, Arg3, Result>(
    _ function: @escaping (Arg0, Arg1, Arg2, Arg3) -> Result,
    _ arg0: Arg0) -> (Arg1, Arg2, Arg3) -> Result {
    return { function(arg0, $0, $1, $2) }
}

public func § <Arg0, Arg1, Arg2, Arg3, Arg4, Result>(
    _ function: @escaping (Arg0, Arg1, Arg2, Arg3, Arg4) -> Result,
    _ arg0: Arg0) -> (Arg1, Arg2, Arg3, Arg4) -> Result {
    return { function(arg0, $0, $1, $2, $3) }
}
