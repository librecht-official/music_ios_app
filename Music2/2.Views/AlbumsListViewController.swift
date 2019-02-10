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
import RxOptional

class AlbumsListViewController: UIViewController {
    typealias State = AlbumsListState
    typealias Command = AlbumsListCommand
    
    private lazy var tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        configureViews()
        
        let tableView = self.tableView
        
        let configureCell: (UITableView, Int, Album) -> UITableViewCell = { tv, row, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "RepositoryCell") ??
                UITableViewCell(style: .subtitle, reuseIdentifier: "RepositoryCell")
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.artist.name
            return cell
        }
        
        let triggerLoadNextPage: (Driver<State>) -> Signal<Command> = { state in
            return state.flatMapLatest { state -> Signal<Command> in
                if state.shouldLoadPage {
                    return Signal.empty()
                }
                return tableView.rx.didScrollNearBottom.map { Command.fetchMore }
            }
        }
        
        let bindUI: (Driver<State>) -> Signal<Command> = bind(self) { (self, state) -> Bindings<Command> in
            let stateToUI = [
                state.map { $0.albums }
                    .distinctUntilChanged()
                    .drive(tableView.rx.items)(configureCell),
                state.map { $0.shouldDisplayError }
                    .filterNil()
                    .drive(onNext: { [unowned self] message in self.displayError(message: message) })
            ]
            let uiToState = [
                triggerLoadNextPage(state)
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
