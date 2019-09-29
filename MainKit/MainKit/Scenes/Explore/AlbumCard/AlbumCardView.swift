//
//  AlbumCardView.swift
//  Music2
//
//  Created by Vladislav Librecht on 28/01/2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core


final class AlbumCardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistButton: UIButton!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var genresView: UIView!
    
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
        coverImageView.contentMode = .scaleAspectFill
        titleLabel.textAlignment = .center
        artistButton.titleLabel?.textAlignment = .center
        genresLabel.textAlignment = .center
        stylesheet.cornerRadius.normal(contentView)
        stylesheet.cornerRadius.normal(coverImageView)
        stylesheet.button.lightPlay(playButton)
        stylesheet.text.headline(titleLabel)
        stylesheet.button.smallText(artistButton)
        stylesheet.view.grayRounded(genresView)
        stylesheet.text.whiteCaption1(genresLabel)
        stylesheet.shadow.card(contentView)
        stylesheet.button.likeTextured(likeButton)
    }
    
    func configure(with album: Album, onPlayButtonTap: @escaping () -> ()) {
        self.onPlayButtonTap = onPlayButtonTap
        coverImageView.kf.setImage(with: album.coverImageURL)
        titleLabel.text = album.title
        artistButton.setTitle(album.artist.name, for: .normal)
        genresLabel.text = "Pop, Hip-hop"
        likeButton.isSelected = false
    }
}

final class AlbumCardCell: MUSCollectionViewCell<AlbumCardView> {
    func configure(with album: Album, onPlayButtonTap: @escaping () -> ()) {
        v.configure(with: album, onPlayButtonTap: onPlayButtonTap)
    }
}
