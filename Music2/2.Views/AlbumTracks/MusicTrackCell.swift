//
//  MusicTrackCell.swift
//  Music2
//
//  Created by Vladislav Librecht on 11.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Reusable

class MusicTrackCell: UITableViewCell, Reusable {
    private lazy var numberLabel = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var durationLabel = UILabel()
    private lazy var stack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
        configureViews()
    }
    
    func configure(withItem item: MusicTrack, number: Int) {
        numberLabel.text = "\(number)."
        titleLabel.text = item.title
        durationLabel.text = item.duration
    }
    
    private func prepareLayout() {
        contentView.addSubview(stack)
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(durationLabel)
        
        [stack, numberLabel, titleLabel, durationLabel].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stack.spacing = 8
        stack.axis = .horizontal
        
        numberLabel.setContentHuggingPriority(.required, for: .horizontal)
        durationLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureViews() {
        backgroundColor = UIColor.clear
        numberLabel.textColor = Color.white.uiColor
        titleLabel.textColor = Color.white.uiColor
        durationLabel.textColor = Color.white.uiColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
