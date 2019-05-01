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
        
        let bindUI: Feedback = bind(self) { (self, state) -> (Bindings<Command>) in
            let stateToUI = [
                state.map { $0.sections }.distinctUntilChanged()
                    .drive(tableView.rx.items(dataSource: self.dataSource))
            ]
            let uiToState = [
                tableView.rx.itemSelected.asSignal()
                    .do(onNext: deselectItem(tableView))
                    .map { Command.didSelectItem(index: $0.row, section: $0.section) }
            ]
            return Bindings(subscriptions: stateToUI, mutations: uiToState)
        }
        
        Driver.system(
            initialState: Explore.initialState,
            reduce: Explore.reduce,
            feedback: bindUI
            )
            .drive()
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
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
        guard let item = dataSource.sectionModels
            .element(at: indexPath.section)?.items
            .element(at: indexPath.row) else {
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
        AutoLayout.constraints(
            view, with: tableView,
            [.safeAreaTop(0), .leading(0), .trailing(0), .bottom(0)]
        )
    }
    
    func configureUI() {
        view.backgroundColor = Color.white.uiColor
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
