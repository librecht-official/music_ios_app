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

final class AlbumCardsCollectionCell: UITableViewCell, Reusable {
    private lazy var collectionLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.estimatedItemSize = AlbumCardsCollectionLayout.itemSize(forContainerWidth: UIScreen.main.bounds.width)
        collectionLayout.minimumLineSpacing = AlbumCardsCollectionLayout.minimumLineSpacing
        collectionView.register(cellType: AlbumCardCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = AlbumCardsCollectionLayout.contentInset
        collectionView.backgroundColor = UIColor.clear
    }
    
    private var albums = [Album]()
    func configure(withAlbums albums: [Album]) {
        self.albums = albums
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource

extension AlbumCardsCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AlbumCardCell.self)
        cell.configure(with: albums[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AlbumCardsCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumCardsCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return AlbumCardsCollectionLayout.itemSize(forContainerWidth: collectionView.bounds.width)
    }
}

enum AlbumCardsCollectionLayout {
    static let contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let minimumLineSpacing = CGFloat(10)
    
    static func itemSize(forContainerWidth width: CGFloat) -> CGSize {
        let width = (width - contentInset.left - contentInset.right - minimumLineSpacing) / 2
        let height = width / 173 * 245
        return CGSize(width: width, height: height)
    }
    
    static func totalHeight(forContainerWidth width: CGFloat) -> CGFloat {
        return itemSize(forContainerWidth: width).height + contentInset.top + contentInset.bottom + 1
        // + 1 for separator
    }
}
