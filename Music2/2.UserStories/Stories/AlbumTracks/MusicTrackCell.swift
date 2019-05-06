//
//  MusicTrackCell.swift
//  Music2
//
//  Created by Vladislav Librecht on 11.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Reusable

final class MusicTrackCell: UITableViewCell, Reusable {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let container = layout(
            LayoutRules(h: .h1(leading: 8, trailing: 8), v: .v1(top: 8, bottom: 8)),
            inBounds: bounds
        )
        let durationLabelWidth = durationLabel
            .sizeThatFits(CGSize(width: 44, height: CGFloat.greatestFiniteMagnitude)).width
        stackRow(
            alignment: .fill, spacing: 8, [
                StackItem({ self.playButton.frame = $0 }, length: .abs(44)),
                StackItem({ self.titleLabel.frame = $0 }, length: .weight(1)),
                StackItem({ self.durationLabel.frame = $0 }, length: .abs(durationLabelWidth)),
                StackItem({ self.likeButton.frame = $0 }, length: .abs(44))
            ],
            inFrame: container
        )
        separatorInset.left = titleLabel.frame.minX
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
