//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


public enum Feedback {
    public typealias Loop<State, Command> = (Driver<State>) -> Signal<Command>
    
    public struct EmptyRequest: Equatable {
        let id = UUID()
        
        public init() {
        }
    }
    
    public struct Request<T>: Equatable {
        let id = UUID()
        public let data: T
        
        public init(_ data: T) {
            self.data = data
        }
        
        public static func == (lhs: Feedback.Request<T>, rhs: Feedback.Request<T>) -> Bool {
            lhs.id == rhs.id
        }
    }
}

public extension Bindings {
    static func empty<Event>() -> Bindings<Event> {
        Bindings<Event>(subscriptions: [Disposable](), events: [Signal<Event>]())
    }
}
