//
//  AlbumCardCell.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Reusable

final class AlbumCardCell: UICollectionViewCell, Reusable {
    struct Style {
        let selectedColor = Color.galleryGray
        let selectionAnimationDuration = AnimationStyle.defaultDuration
        
        let shadow = ShadowStyle()
        let cornerRadius = CGFloat(13)
        var view: AlbumCellView.Style = { () -> AlbumCellView.Style in
            var s = AlbumCellView.Style()
            s.coverImageCornerRadius = 8
            s.title.alignment = .center
            s.artist.alignment = .center
            s.likeButton = IconButtonStyle(
                normalIcon: Asset.like2Unselected34x31,
                selectedIcon: Asset.like2Selected34x31,
                tintColor: Color.primaryBlue
            )
            s.disclosureIndicator = nil
            return s
        }()
    }
    var style = Style() { didSet { apply(style: style) } }
    func apply(style: Style) {
        applyShadow(style: style.shadow)
        view.layer.cornerRadius = style.cornerRadius
        view.apply(style: style.view)
    }
    
    private let view = AlbumCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view.makeLayout = AlbumViewLayout.makeCardLayout
        contentView.addSubview(view)
        selectedBackgroundView = UIView()
        apply(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = contentView.bounds
    }
    
    func configure(with album: Album) {
        view.configure(with: album)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                view.backgroundColor = style.selectedColor.uiColor
            }
            else {
                view.backgroundColor = view.style.backgroundColor.uiColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                view.backgroundColor = style.selectedColor.uiColor
            }
            else {
                view.backgroundColor = view.style.backgroundColor.uiColor
            }
        }
    }
}
