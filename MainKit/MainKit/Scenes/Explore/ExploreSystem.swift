//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import Core


extension Explore {
    public typealias Env = MusicAPIEnvironment & AudioPlayerEnvironment
    typealias Loop = Feedback.Loop<State, Command>
    
    static func run(env: Env, uiLoop: @escaping Loop) -> Driver<State> {
        let effectsLoop: Loop = react(request: { $0.effect }) { request -> Signal<Command> in
            switch request.data {
            case .fetchExploreSummary:
                return env.musicAPI.explore().toResultSignal().map { Command.didFetch($0) }
            case let .setPlayerCommands(commands):
                commands.forEach { cmd in env.audioPlayer.command.accept(cmd) }
                return .never()
            }
        }
        
        return Driver.system(
            initialState: State(),
            reduce: reduce,
            feedback: [uiLoop, effectsLoop]
        )
    }
}
