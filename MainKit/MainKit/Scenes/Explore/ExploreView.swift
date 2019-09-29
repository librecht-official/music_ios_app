//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources
import Reusable
import Core


final class ExploreViewController: MUSViewController<ExploreView> {
    private var searchController: UISearchController?
    private let didSelectAlbumInCard = PublishSubject<Album>()
    
    typealias Event = Explore.Command
    typealias Binding = (@escaping Explore.Loop) -> Driver<Explore.State>
    private let _bind: Binding
    
    init(bind: @escaping Binding) {
        self._bind = bind
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = configureSearchController()
        v.tableView.register(headerFooterViewType: TitleTableHeaderView.self)
        v.tableView.register(cellType: AlbumRowCell.self)
        v.tableView.register(cellType: AlbumCardsCollectionCell.self)
        v.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let tableView = v.tableView!
        
        let uiBinding: Explore.Loop = bind(self) { (self, state) -> (Bindings<Event>) in
            Bindings<Event>(
                subscriptions: [
                    state.map { $0.sections }.distinctUntilChanged()
                        .drive(tableView.rx.items(dataSource: self.dataSource)),
                    state.map { $0.showLoading }.drive(self.v.activityIndicator.rx.isAnimating),
                    state.map { $0.showLoading }.drive(tableView.rx.isHidden),
                    state.map { $0.showLoading }.filter { !$0 }
                        .drive(self.v.refreshControl.rx.isRefreshing),
                ],
                events: [
                    self.itemSelected(in: tableView),
                    self.didSelectAlbumInCard.asSignal(onErrorSignalWith: .never())
                        .map { Event.didSelectAlbum($0) },
                    self.v.refreshControl.rx.pullToRefreshSignal.map { Event.reFetch },
                    self.playAlbumSubject.asSignal().map { Event.playAlbum($0) }
                ]
            )
        }
        _bind(uiBinding).drive().disposed(by: disposeBag)
    }
    
    private func itemSelected(in tableView: UITableView) -> Signal<Event> {
        return tableView.rx.itemSelected.asSignal()
            .do(onNext: deselectItem(tableView))
            .map { [unowned self] ip -> Event? in
                return self.albumInRow(at: ip).map { Event.didSelectAlbum($0) }
            }
            .filterNil()
    }
    
    private func albumInRow(at indexPath: IndexPath) -> Album? {
        let item = dataSource[indexPath]
        switch item {
            case let .albumRow(album): return album
            case .albumCardsCollection: return nil
        }
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<Explore.Section>(
        configureCell: { [unowned self] (ds, tv, ip, item) -> UITableViewCell in
            switch item {
            case let .albumRow(album):
                let cell = tv.dequeueReusableCell(for: ip, cellType: AlbumRowCell.self)
                cell.configure(with: album) { [weak self] in
                    self?.play(album: album)
                }
                return cell
                
            case let .albumCardsCollection(albums):
                let cell = tv.dequeueReusableCell(for: ip, cellType: AlbumCardsCollectionCell.self)
                cell.configure(withAlbums: albums)
                cell.didSelectAlbumObserver = self.didSelectAlbumInCard.asObserver()
                cell.configure(onPlayButtonTap: { [weak self] album in
                    self?.play(album: album)
                })
                return cell
            }
    })
    
    private let playAlbumSubject = PublishRelay<Album>()
    private func play(album: Album) {
        playAlbumSubject.accept(album)
    }
    
    private func configureSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.backgroundColor = stylesheet().color.background
        controller.searchBar.barTintColor = stylesheet().color.primaryTint
        v.tableView.tableHeaderView = controller.searchBar
        definesPresentationContext = true
        return controller
    }
}

// MARK: - UITableViewDelegate

extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataSource.numberOfSections(in: tableView) > section else {
            return nil
        }
        let title = dataSource[section].headerTitle
        let header = tableView.dequeueReusableHeaderFooterView(TitleTableHeaderView.self)
        header?.configure(title: title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard dataSource.numberOfSections(in: tableView) > section else {
            return 0
        }
        return 42
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath] {
        case .albumRow:
            return 80
        case .albumCardsCollection:
            return albumCardsTotalHeight(forContainerWidth: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
}

// MARK: - ExploreView

final class ExploreView: UIView, NibLoadable {
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var activityIndicator: UIActivityIndicatorView!
    private(set) lazy var refreshControl = UIRefreshControl()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stylesheet().view.background(self)
        stylesheet().view.background(refreshControl)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }
}

extension Explore.Section: SectionModelType {
    typealias Item = Explore.Item
    
    init(original: Explore.Section, items: [Explore.Item]) {
        self = original
        self.items = items
    }
}
