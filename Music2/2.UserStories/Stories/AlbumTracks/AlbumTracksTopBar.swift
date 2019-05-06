//
//  AlbumTracksTopBar.swift
//  Music2
//
//  Created by Vladislav Librecht on 17.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

class AlbumTracksTopBar: UIView {
    private lazy var effect = UIVisualEffectView(
        effect: UIBlurEffect(style: .regular)
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
