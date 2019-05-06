//
//  AlbumTracksViewController.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import Kingfisher

class AlbumTracksViewController: UIViewController, NavigationBarCustomization {
    typealias State = AlbumTracksState
    typealias Command = AlbumTracksCommand
    
    var navigationBarShouldBeHidden: Bool = true
    private lazy var topBar = AlbumTracksTopBar()
    
    private lazy var coverImage = UIImageView()
    private lazy var albumTitle = UILabel()
    private lazy var artist = UILabel()
    private lazy var tableView = UITableView()
    private var headerHeight: NSLayoutConstraint!
    
    private let album: Album
    private let disposeBag = DisposeBag()
    
    private let layout = LayoutGuide()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        configureViews()
        
        let tableView = self.tableView
        
        tableView.rx.contentOffset
            .bind(onNext: { [unowned self] offset in
                self.contentOffsetChanged(offset)
            })
            .disposed(by: disposeBag)
        
        let displayTracks: (Driver<State>) -> Disposable = { state in
            state.map { $0.album.tracks }.distinctUntilChanged()
                .drive(
                    tableView.rx.items(
                        cellIdentifier: MusicTrackCell.reuseIdentifier,
                        cellType: MusicTrackCell.self
                    )
                ) { (i, item, cell) in cell.configure(withItem: item, number: i + 1) }
        }
        
        let bindUI: (Driver<State>) -> Signal<Command> = bind(self) { (self, state) -> Bindings<Command> in
            let stateToUI = [
                displayTracks(state)
            ]
            let uiToState = [
                tableView.rx.itemSelected
                    .do(onNext: deselectItem(tableView))
                    .map { Command.didSelectItem(at: $0.row) }
                    .asSignal(onErrorSignalWith: Signal.empty())
            ]
            return Bindings(subscriptions: stateToUI, mutations: uiToState)
        }
        
        let bindAudio: (Driver<State>) -> Signal<Command> = react(
            query: { $0.shouldPlayPlaylist },
            effects: { playlist in
                Environment.current.audioPlayer.playlist.accept(playlist)
                Environment.current.audioPlayer.command.onNext(.play)
                return Signal.just(Command.didStartPlayingTrack)
            }
        )
        
        Driver.system(
            initialState: AlbumTracks.initialState(album: album),
            reduce: AlbumTracks.reduce,
            feedback: bindUI, bindAudio
            )
            .drive()
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        coverImage.kf.setImage(with: album.coverImageURL)
        albumTitle.text = album.title
        artist.text = album.artist.name
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentInset.bottom += additionalSafeAreaInsets.bottom
    }
}

// MARK: - UITableViewDelegate

extension AlbumTracksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MusicTrackCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
}

// MARK: - Private

private extension AlbumTracksViewController {
    func prepareLayout() {
        tableView.contentInsetAdjustmentBehavior = .never
        
        let header = UIView()
        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(topBar)
        header.addSubview(coverImage)
        header.addSubview(albumTitle)
        header.addSubview(artist)
        tableView.contentInset.top += layout.headerMaxHeight
        
        [tableView, coverImage, albumTitle, artist, header, topBar]
            .forEach { v in v.translatesAutoresizingMaskIntoConstraints = false }
        
        headerHeight = header.heightAnchor.constraint(equalToConstant: layout.headerMaxHeight)
        
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            header.topAnchor.constraint(equalTo: view.topAnchor),
            headerHeight,
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            coverImage.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            coverImage.topAnchor.constraint(equalTo: header.topAnchor),
            coverImage.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            
            albumTitle.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            albumTitle.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8),
            albumTitle.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8),
            
            artist.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            artist.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8),
            artist.bottomAnchor.constraint(equalTo: albumTitle.topAnchor, constant: -8),
        ])
    }
    
    func configureViews() {
        view.backgroundColor = Color.white.uiColor
        
        topBar.titleLabel.text = album.title
        topBar.backButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.register(cellType: MusicTrackCell.self)
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        tableView.bounces = true
        
        coverImage.clipsToBounds = true
        coverImage.contentMode = .scaleAspectFill
        
        albumTitle.font = Font.barTitle.uiFont
        albumTitle.textColor = Color.white.uiColor
        
        artist.textColor = Color.white.uiColor
    }
    
    func contentOffsetChanged(_ offset: CGPoint) {
        headerHeight.constant = layout.headerHeight(
            forContentOffsetY: offset.y,
            navBarTotalHeight: topBar.bounds.height
        )
        let alpha = layout.navBarAlpha(
            forContentOffsetY: offset.y,
            navBarTotalHeight: topBar.bounds.height
        )
        topBar.set(transparency: alpha)
        albumTitle.alpha = 1.0 - alpha
    }
}

extension AlbumTracksViewController {
    struct LayoutGuide {
        let headerMaxHeight = CGFloat(300)
        
        func navBarAlpha(forContentOffsetY oy: CGFloat, navBarTotalHeight: CGFloat) -> CGFloat {
            let y = -oy
            return (headerMaxHeight - max(min(y, headerMaxHeight), navBarTotalHeight))
                / (headerMaxHeight - navBarTotalHeight)
        }
        
        func headerHeight(forContentOffsetY oy: CGFloat, navBarTotalHeight: CGFloat) -> CGFloat {
            return max(-oy, navBarTotalHeight)
        }
    }
}
