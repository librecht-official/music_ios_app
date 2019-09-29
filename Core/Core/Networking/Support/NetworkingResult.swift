//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


public typealias NetworkingResult<T: Decodable> = Result<T, Error>


//public enum NetworkingError: Error {
//    case api(Error)
//}
//
//
//public extension Single where Element: Decodable {
//    func networkingSignal() -> Signal<NetworkingResult<Element>> {
//        return self.asObservable()
//            .map { NetworkingResult<Element>.success($0) }
//            .asSignal(onErrorRecover: { Signal.just(.failure(.api($0))) })
//    }
//}
