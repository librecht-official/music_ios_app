//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa


public extension Single {
    func toResultSignal() -> Signal<Result<Element, Error>> {
        self.asObservable()
            .map(Result<Element, Error>.success)
            .asSignal { error -> Signal<Result<Element, Error>> in
                .just(Result<Element, Error>.failure(error))
            }
    }
}
