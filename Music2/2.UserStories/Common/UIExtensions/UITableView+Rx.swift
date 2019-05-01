//
//  UITableView+Rx.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    var didScrollNearBottom: Signal<()> {
        func isNearBottomEdge(tableView: UITableView, edgeOffset: CGFloat = 50.0) -> Bool {
            if tableView.contentSize.height < tableView.frame.size.height {
                return tableView.contentOffset.y > 0
            }
            return tableView.contentOffset.y + tableView.frame.size.height + edgeOffset > tableView.contentSize.height
        }
        
        return self.contentOffset.asDriver()
            .flatMap { _ in
                return isNearBottomEdge(tableView: self.base) ? Signal.just(()) : Signal.empty()
        }
    }
}

let deselectItem: (UITableView) -> (IndexPath) -> () = { tableView in
    return {
        tableView.deselectRow(at: $0, animated: true)
    }
}
