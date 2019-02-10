//
//  AlbumsListViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 20.01.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources
import RxOptional
import Reusable

class AlbumsListViewController: UIViewController {
    typealias State = AlbumsListState
    typealias Command = AlbumsListCommand
    
    private lazy var tableView = UITableView()
    private lazy var bottomIndicator = infiniteScrollingIndicator()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        configureViews()
        
        let tableView = self.tableView
        
        let configureCell: (Int, Album, AlbumCell) -> () = { _, item, cell in
            cell.configure(withItem: item)
        }
        
        let displayError = { [unowned self] message in self.displayError(message: message) }
        
        let triggerLoadNextPage: (Driver<State>) -> Signal<Command> = { state in
            return state.flatMapLatest { state -> Signal<Command> in
                if state.shouldLoadPage {
                    return Signal.empty()
                }
                return tableView.rx.didScrollNearBottom.map { Command.fetchMore }
            }
        }
        
        let deselectItem: (IndexPath) -> () = { tableView.deselectRow(at: $0, animated: true) }
        let openAlbum: (Album) -> () = { album in print("Open album: \(album)") }
        
        let bindUI: (Driver<State>) -> Signal<Command> = bind(self) { (self, state) -> Bindings<Command> in
            let stateToUI = [
                state.map { $0.albums }.distinctUntilChanged()
                    .drive(tableView.rx.items(
                        cellIdentifier: AlbumCell.reuseIdentifier,
                        cellType: AlbumCell.self)
                    )(configureCell),
                state.map { $0.shouldDisplayError }.filterNil().drive(onNext: displayError),
                state.map { $0.shouldLoadPage }.drive(self.bottomIndicator.rx.isAnimating),
                state.map { $0.shouldOpenAlbum }.filterNil().drive(onNext: openAlbum)
            ]
            let uiToState = [
                triggerLoadNextPage(state),
                tableView.rx.itemSelected
                    .do(onNext: deselectItem)
                    .map { Command.didSelectItem(at: $0.row) }
                    .asSignal(onErrorSignalWith: Signal.empty())
            ]
            return Bindings(subscriptions: stateToUI, mutations: uiToState)
        }
        
        let bindAPI: (Driver<State>) -> Signal<Command> = react(
            query: { $0.nextFetchRequest },
            effects: {
                AlbumsNetworking.getAlbums(AlbumsAPIRequest(offset: $0.offset))
                    .asSignal()
                    .map { Command.didFetchMore($0) }
            }
        )
        
        Driver.system(
            initialState: AlbumsList.initialState,
            reduce: AlbumsList.reduce,
            feedback: bindUI, bindAPI
            )
            .drive()
            .disposed(by: disposeBag)
    }
    
    func prepareLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func configureViews() {
        view.backgroundColor = Color.blackBackground.uiColor
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 90
        tableView.register(cellType: AlbumCell.self)
        tableView.tableFooterView = bottomIndicator
    }
    
    func displayError(message: String) {
        if isMovingFromParent || presentedViewController != nil {
            return
        }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

func infiniteScrollingIndicator() -> UIActivityIndicatorView {
    let i = UIActivityIndicatorView(style: .white)
    i.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    i.hidesWhenStopped = true
    return i
}
