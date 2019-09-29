//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


// MARK: - UITableView

public let deselectItem: (UITableView) -> (IndexPath) -> () = { tableView in
    return {
        tableView.deselectRow(at: $0, animated: true)
    }
}

// MARK: - UIRefreshControl

public extension Reactive where Base: UIRefreshControl {
    var pullToRefreshSignal: Signal<Void> {
        return self.controlEvent(UIControl.Event.valueChanged).asSignal()
    }
}
