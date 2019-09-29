//
//  AlbumRowView.swift
//  Music2
//
//  Created by Vladislav Librecht on 28/01/2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import Core


final class AlbumRowView: UIView {
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistButton: UIButton!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var genresView: UIView!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    private var onPlayButtonTap: (() -> ())?
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.rx.tap.asSignal()
            .emit(onNext: { [unowned self] in self.onPlayButtonTap?() })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        apply(stylesheet: stylesheet())
        super.layoutSubviews()
    }
    
    func apply(stylesheet: StylesheetType) {
        backgroundColor = UIColor.clear
        artistButton.titleLabel?.textAlignment = .natural
        stylesheet.cornerRadius.normal(coverImageView)
        stylesheet.button.lightPlay(playButton)
        stylesheet.text.headline(titleLabel)
        stylesheet.button.smallText(artistButton)
        stylesheet.text.minorFootnote(yearLabel)
        stylesheet.view.grayRounded(genresView)
        stylesheet.text.whiteCaption1(genresLabel)
        stylesheet.button.like(likeButton)
    }
    
    func configure(with album: Album, onPlayButtonTap: @escaping () -> ()) {
        self.onPlayButtonTap = onPlayButtonTap
        coverImageView.kf.setImage(with: album.coverImageURL)
        titleLabel.text = album.title
        artistButton.setTitle(album.artist.name, for: .normal)
        yearLabel.text = "2017"
        genresLabel.text = "Pop, Hip-hop"
        likeButton.isSelected = false
    }
}

final class AlbumRowCell: MUSTableViewCell<AlbumRowView> {
    override func layoutSubviews() {
        accessoryType = .disclosureIndicator
        super.layoutSubviews()
    }
    
    func configure(with album: Album, onPlayButtonTap: @escaping () -> ()) {
        v.configure(with: album, onPlayButtonTap: onPlayButtonTap)
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        guard let style = style else { return }
//        let color = selected ?
//            style.selectedColor :
//            view.style.backgroundColor
//        UIView.animate(withDuration: style.selectionAnimationDuration) {
//            self.view.backgroundColor = color
//        }
//    }

//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        guard let style = style else { return }
//        let color = highlighted ?
//            style.selectedColor :
//            view.style.backgroundColor
//        UIView.animate(withDuration: style.selectionAnimationDuration) {
//            self.view.backgroundColor = color
//        }
//    }
}
