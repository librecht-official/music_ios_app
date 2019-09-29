//
//  AlbumCardsCollectionCell.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import Core


final class AlbumCardsCollectionCell: UITableViewCell, Reusable {
    private lazy var collectionLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    
    var didSelectAlbumObserver: AnyObserver<Album>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = minimumLineSpacing
        collectionView.register(cellType: AlbumCardCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = contentInset
        collectionView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private var albums = [Album]()
    func configure(withAlbums albums: [Album]) {
        self.albums = albums
        collectionView.reloadData()
    }
    
    private var onPlayButtonTap: ((Album) -> Void)?
    func configure(onPlayButtonTap: @escaping ((Album) -> Void)) {
        self.onPlayButtonTap = onPlayButtonTap
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

// MARK: - UICollectionViewDataSource

extension AlbumCardsCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AlbumCardCell.self)
        let album = albums[indexPath.item]
        cell.configure(with: album) { [weak self] in
            self?.onPlayButtonTap?(album)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AlbumCardsCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectAlbumObserver?.onNext(albums[indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumCardsCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return itemSize(forContainerWidth: collectionView.bounds.width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

// MARK: - Layout

private let contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
private let minimumLineSpacing = CGFloat(10)

private func itemSize(forContainerWidth width: CGFloat) -> CGSize {
    let width = (width - contentInset.left - contentInset.right - minimumLineSpacing) / 2
    let height = width / 173 * 245
    return CGSize(width: width, height: height)
}

func albumCardsTotalHeight(forContainerWidth width: CGFloat) -> CGFloat {
    return itemSize(forContainerWidth: width).height + contentInset.top + contentInset.bottom + 1
    // + 1 for separator
}
