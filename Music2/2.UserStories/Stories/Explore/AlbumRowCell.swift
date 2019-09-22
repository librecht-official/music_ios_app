//
//  AlbumRowCell.swift
//  Music2
//
//  Created by Vladislav Librecht on 29.04.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Reusable

final class AlbumRowCell: UITableViewCell, Reusable {
    struct Style {
        let selectedColor = Color.galleryGray
        let selectionAnimationDuration = AnimationStyle.defaultDuration
    }
    var style = Style()
    
    private let view = AlbumCellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        view.makeLayout = AlbumViewLayout.makeRowLayout
        contentView.addSubview(view)
        selectedBackgroundView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = contentView.bounds
    }
    
    // MARK: Configuration
    
    func configure(with album: Album) {
        view.configure(with: album)        
    }
    
    func configure(onPlayButtonTap: @escaping (() -> Void)) {
        view.onPlayButtonTap = onPlayButtonTap
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = selected ?
            style.selectedColor.uiColor :
            view.style.backgroundColor.uiColor
        UIView.animate(withDuration: style.selectionAnimationDuration) {
            self.view.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = highlighted ?
            style.selectedColor.uiColor :
            view.style.backgroundColor.uiColor
        UIView.animate(withDuration: style.selectionAnimationDuration) {
            self.view.backgroundColor = color
        }
    }
}
