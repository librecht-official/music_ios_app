//
//  AlbumCell.swift
//  Music2
//
//  Created by Vladislav Librecht on 10.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class AlbumCell: UITableViewCell, Reusable {
    private lazy var coverView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var artistLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
        configureViews()
    }
    
    func configure(withItem item: Album) {
        coverView.kf.setImage(with: item.coverImageURL)
        titleLabel.text = item.title
        artistLabel.text = item.artist.name
    }
    
    private func prepareLayout() {
        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        
        [coverView, titleLabel, artistLabel].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            coverView.heightAnchor.constraint(equalTo: coverView.widthAnchor, multiplier: 1),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: artistLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            
            artistLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            artistLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 8),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
        ])
    }
    
    private func configureViews() {
        backgroundColor = UIColor.clear
        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 5
        titleLabel.textColor = Color.white.uiColor
        artistLabel.textColor = Color.lightGray.uiColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
