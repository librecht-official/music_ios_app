//
//  ExploreViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 28.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources
import Reusable

extension ExploreSection: SectionModelType {
    typealias Item = ExploreItem
    
    init(original: ExploreSection, items: [ExploreItem]) {
        self = original
        self.items = items
    }
}

final class ExploreViewController: UIViewController {
    typealias State = ExploreState
    typealias Command = ExploreCommand
    typealias Feedback = DriverFeedback<State, Command>
    
    private var searchController: UISearchController!
    private lazy var tableView = UITableView()
    private lazy var activityIndicator = loadingIndicator()
    private lazy var refreshControl = UIRefreshControl()
    private lazy var nothingHereView = InformationView(viewModel: InformationViewModel.nothingHere)
    
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ExploreSection>(
        configureCell: { (ds, tv, ip, item) -> UITableViewCell in
            switch item {
            case let .albumRow(album):
                let cell = tv.dequeueReusableCell(for: ip, cellType: AlbumRowCell.self)
                cell.configure(with: album)
                return cell
            case let .albumCardsCollection(albums):
                let cell = tv.dequeueReusableCell(for: ip, cellType: AlbumCardsCollectionCell.self)
                cell.configure(withAlbums: albums)
                return cell
            }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        configureUI()
        
        let tableView = self.tableView
        let rc = self.refreshControl
        let activityIndicator = self.activityIndicator
        let nothingHereView = self.nothingHereView
        
        let bindUI: Feedback = bind(self) { (self, state) -> (Bindings<Command>) in
            let stateToUI = [
                state.map { $0.sections }.distinctUntilChanged()
                    .drive(tableView.rx.items(dataSource: self.dataSource)),
                state.map { $0.showLoading }.drive(activityIndicator.rx.isAnimating),
                state.map { $0.showLoading }.drive(tableView.rx.isHidden),
                state.map { $0.showLoading }.filter { !$0 }.drive(rc.rx.isRefreshing),
                state.map { !$0.nothingHere }.drive(nothingHereView.rx.isHidden),
            ]
            let uiToState = [
                self.itemSelected(in: tableView),
                rc.rx.pullToRefreshSignal.map { Command.reFetch }
            ]
            return Bindings(subscriptions: stateToUI, mutations: uiToState)
        }
        
        let bindAPI: Feedback = react(query: { $0.loadingRequest }) { _ -> Signal<Command> in
            return Environment.current.api.music.explore().asSignal()
                .map { Command.didFetch($0) }
        }
        
        Driver.system(
            initialState: Explore.initialState,
            reduce: Explore.reduce,
            feedback: bindUI, bindAPI
            )
            .drive()
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func itemSelected(in tableView: UITableView) -> Signal<Command> {
        return tableView.rx.itemSelected.asSignal()
            .do(onNext: deselectItem(tableView))
            .map { [unowned self] ip -> Command? in
                return self.albumInRow(at: ip).map { Command.didSelectAlbum($0) }
            }
            .filterNil()
    }
    
    private func albumInRow(at indexPath: IndexPath) -> Album? {
        if let item = dataSource.item(at: indexPath) {
            switch item {
            case let .albumRow(album): return album
            case .albumCardsCollection: return nil
            }
        }
        return nil
    }
}

// MARK: - UITableViewDelegate

extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.sectionModels.element(at: section)?.headerTitle else {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(TitleTableHeaderView.self)
        header?.configure(title: title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TitleHeaderView.desiredHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = dataSource.item(at: indexPath) else {
            return 0
        }
        switch item {
        case .albumRow:
            return AlbumViewLayout.rowHeight
        case .albumCardsCollection:
            return AlbumCardsCollectionLayout.totalHeight(forContainerWidth: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
}

// MARK: - Private

private extension ExploreViewController {
    func prepareLayout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(nothingHereView)
        tableView.refreshControl = refreshControl
        AutoLayout.constraints(
            view, with: tableView,
            [.safeAreaTop(0), .leading(0), .trailing(0), .bottom(0)]
        )
        AutoLayout.constraint(view, .centerX, with: activityIndicator, .centerX)
        AutoLayout.constraint(view, .centerY, with: activityIndicator, .centerY)
        AutoLayout.constraints(
            view, with: nothingHereView,
            [.safeAreaTop(0), .leading(0), .trailing(0), .safeAreaBottom(0)]
        )
    }
    
    func configureUI() {
        view.backgroundColor = Color.white.uiColor
        refreshControl.backgroundColor = Color.white.uiColor
        nothingHereView.isUserInteractionEnabled = false
        tableView.register(headerFooterViewType: TitleTableHeaderView.self)
        tableView.register(cellType: AlbumRowCell.self)
        tableView.register(cellType: AlbumCardsCollectionCell.self)
        tableView.tableFooterView = UIView()
        searchController = configureSearchController()
    }
    
    func configureSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = true
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.backgroundColor = Color.white.uiColor
        controller.searchBar.barTintColor = Color.primaryBlue.uiColor
        tableView.tableHeaderView = controller.searchBar
        definesPresentationContext = true
        return controller
    }
}
