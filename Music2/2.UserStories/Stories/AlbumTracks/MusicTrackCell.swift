//
//  MusicTrackCell.swift
//  Music2
//
//  Created by Vladislav Librecht on 11.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Reusable
import Layout

final class MusicTrackCell: UITableViewCell, Reusable {
    // MARK: Style
    
    struct Style {
        let play = IconButtonStyle(
            normalIcon: Asset.playInRound33x33, tintColor: Color.primaryBlue
        )
        let title = LabelStyle(font: Font.regular(16), textColor: Color.blackText)
        let duration = LabelStyle(font: Font.regular(16), textColor: Color.lightGrayText)
        let like = IconButtonStyle.like
    }
    private(set) var style = Style()
    func apply(style: Style) {
        self.style = style
        playButton.apply(style: style.play)
        titleLabel.apply(style: style.title)
        durationLabel.apply(style: style.duration)
        likeButton.apply(style: style.like)
    }
    
    // MARK: Properties
    
    static let preferredHeight = CGFloat(50)
    
    private lazy var playButton = UIButton()
    private lazy var titleLabel = UILabel()
    private lazy var durationLabel = UILabel()
    private lazy var likeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(playButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(likeButton)
        apply(style: self.style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    func configure(withItem item: MusicTrack, number: Int) {
        titleLabel.text = item.title
        durationLabel.text = item.duration
        configureAs(enabled: item.isAudioAvailable)
        setNeedsLayout()
    }
    
    private func configureAs(enabled: Bool) {
        selectionStyle = enabled ? .default : .none
        playButton.isEnabled = enabled
        titleLabel.alpha = enabled ? 1.0 : 0.5
    }
    
    // MARK: Layout
    
    private func makeLayout() -> LayoutComponent {
        return VirtualContainer(
            .h1(leading: 8, trailing: 8),
            .v1(top: 8, bottom: 8),
            sub: Row(spacing: 8, [
                RowItem.fixed(width: .abs(44), Component(playButton)),
                RowItem.fixed(width: .weight(1), Component(titleLabel)),
                RowItem.fixed(width: .abs(44), Component(durationLabel)),
                RowItem.fixed(width: .abs(44), Component(likeButton))
                ]
            )
        )
    }
    private(set) lazy var layout = makeLayout()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.performLayout(inFrame: bounds)
        separatorInset.left = titleLabel.frame.minX
    }
}
