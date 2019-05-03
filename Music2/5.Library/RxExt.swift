//
//  Rx.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import RxSwift
import RxCocoa
import Result
import RxDataSources

extension Single where Element: Decodable {
    func asSignal() -> Signal<NetworkingResult<Element>> {
        return self.asObservable()
            .map { NetworkingResult<Element>.success($0) }
            .asSignal(onErrorRecover: { Signal.just(.failure(AnyError($0))) })
    }
}

extension TableViewSectionedDataSource {
    func item(at indexPath: IndexPath) -> I? {
        return self.sectionModels.element(at: indexPath.section)?.items.element(at: indexPath.row)
    }
}
