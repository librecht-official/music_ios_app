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

class AlbumTracksNavigationBar: UIView {
    private lazy var effect = UIVisualEffectView(
        effect: UIBlurEffect(style: .light)
    )
    lazy var titleLabel = UILabel()
    lazy var backButton = UIButton(type: .system)
    
    func set(transparency: CGFloat) {
        effect.alpha = transparency
        titleLabel.alpha = transparency
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareLayout() {
        addSubview(effect)
        addSubview(titleLabel)
        addSubview(backButton)
        
        [effect, titleLabel, backButton]
            .forEach { v in v.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            effect.topAnchor.constraint(equalTo: topAnchor),
            effect.bottomAnchor.constraint(equalTo: bottomAnchor),
            effect.leadingAnchor.constraint(equalTo: leadingAnchor),
            effect.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
    }
    
    func configureViews() {
        titleLabel.textColor = Color.black.uiColor
        titleLabel.font = Font.bold(16).uiFont
        
        backButton.tintColor = Color.white.uiColor
        backButton.setImage(Asset.back12x20.image, for: .normal)
    }
}

class AlbumTracksViewController: UIViewController, NavigationBarCustomization {
    typealias State = AlbumTracksState
    typealias Command = AlbumTracksCommand
    
    var navigationBarShouldBeHidden: Bool = true
    private lazy var navigationBar = AlbumTracksNavigationBar()
    
    private lazy var coverImage = UIImageView()
    private lazy var gradient = GradientView(top: UIColor.clear, bottom: Color.blackBackground.uiColor.withAlphaComponent(0.8))
    private lazy var albumTitle = UILabel()
    private lazy var artist = UILabel()
    private lazy var tracks = UITableView()
    private var headerTop: NSLayoutConstraint!
    private var headerHeight: NSLayoutConstraint!
    private var titleLeading: NSLayoutConstraint!
    
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
        
        let tableView = tracks
        
        tableView.rx.contentOffset
            .bind(onNext: { [unowned self] offset in
                self.contentOffsetChanged(offset)
            })
            .disposed(by: disposeBag)
        
        let bindUI: (Driver<State>) -> Signal<Command> = bind(self) { (self, state) -> Bindings<Command> in
            let stateToUI = [
                state.map { $0.album.tracks }.distinctUntilChanged()
                    .drive(
                        tableView.rx.items(
                            cellIdentifier: MusicTrackCell.reuseIdentifier,
                            cellType: MusicTrackCell.self
                        )
                    ) { (i, item, cell) in cell.configure(withItem: item, number: i + 1) }
            ]
            let uiToState = [Signal<Command>]()
            return Bindings(subscriptions: stateToUI, mutations: uiToState)
        }
        
        Driver.system(
            initialState: AlbumTracks.initialState(album: album),
            reduce: AlbumTracks.reduce,
            feedback: bindUI
            )
            .drive()
            .disposed(by: disposeBag)
        
        coverImage.kf.setImage(with: album.coverImageURL)
        albumTitle.text = album.title
        artist.text = album.artist.name
    }
}

private extension AlbumTracksViewController {
    func prepareLayout() {
        tracks.contentInsetAdjustmentBehavior = .never
        
        let header = UIView()
        view.addSubview(header)
        view.addSubview(tracks)
        view.addSubview(navigationBar)
        header.addSubview(coverImage)
        header.addSubview(gradient)
        header.addSubview(albumTitle)
        header.addSubview(artist)
        tracks.contentInset.top += layout.headerMaxHeight
        tracks.contentInset.bottom += 20
        
        [tracks, coverImage, albumTitle, artist, gradient, header, navigationBar]
            .forEach { v in v.translatesAutoresizingMaskIntoConstraints = false }
        
        headerTop = header.topAnchor.constraint(equalTo: view.topAnchor)
        headerHeight = header.heightAnchor.constraint(equalToConstant: layout.headerMaxHeight)
        titleLeading = albumTitle.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            tracks.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tracks.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tracks.topAnchor.constraint(equalTo: view.topAnchor),
            tracks.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerTop,
            headerHeight,
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            coverImage.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            coverImage.topAnchor.constraint(equalTo: header.topAnchor),
            coverImage.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            
            gradient.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            gradient.topAnchor.constraint(equalTo: header.topAnchor),
            gradient.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            
            titleLeading,
            albumTitle.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8),
            albumTitle.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8),
            
            artist.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            artist.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8),
            artist.bottomAnchor.constraint(equalTo: albumTitle.topAnchor, constant: -8),
        ])
    }
    
    func configureViews() {
        view.backgroundColor = Color.blackBackground.uiColor
        
        navigationBar.titleLabel.text = album.title
        navigationBar.backButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        tracks.register(cellType: MusicTrackCell.self)
        tracks.rowHeight = layout.rowHeight
        tracks.backgroundColor = UIColor.clear
        tracks.tableFooterView = UIView()
        tracks.alwaysBounceVertical = true
        tracks.bounces = true
        
        coverImage.clipsToBounds = true
        coverImage.contentMode = .scaleAspectFill
        
        albumTitle.font = Font.barTitle.uiFont
        albumTitle.textColor = Color.white.uiColor
        
        artist.textColor = Color.white.uiColor
    }
    
    func contentOffsetChanged(_ offset: CGPoint) {
        headerHeight.constant = layout.headerHeight(
            forContentOffsetY: offset.y,
            navBarTotalHeight: navigationBar.bounds.height
        )
        let alpha = layout.navBarAlpha(
            forContentOffsetY: offset.y,
            navBarTotalHeight: navigationBar.bounds.height
        )
        navigationBar.set(transparency: alpha)
        albumTitle.alpha = 1.0 - alpha
    }
}

extension AlbumTracksViewController {
    struct LayoutGuide {
        let headerMaxHeight = CGFloat(300)
        let rowHeight = CGFloat(44)
        
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
