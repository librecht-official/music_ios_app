//
//  AlbumCellView.swift
//  Music2
//
//  Created by Vladislav Librecht on 02.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Kingfisher
import Layout
import RxSwift
import RxCocoa

struct AlbumCellViewModel {
    let info: AlbumInfoViewModel
}

struct AlbumInfoViewModel {
    let year: LabelViewModel
}

final class AlbumCellView: UIView {
    // MARK: Style
    
    struct Style {
        let backgroundColor = Color.white
        var coverImageCornerRadius = CGFloat(4)
        let coverImageBackgroundColor = Color.primaryBlue
        let playButton = IconButtonStyle(
            normalIcon: Asset.playWhite39x40, tintColor: Color.white
        )
        var title = LabelStyle(font: Font.semibold(18), textColor: Color.blackText)
        var artist = LabelStyle(font: Font.regular(14), textColor: Color.primaryBlue)
        let year = LabelStyle(font: Font.regular(14), textColor: Color.lightGrayText)
        let genres = GenresView.Style()
        var likeButton = IconButtonStyle(
            normalIcon: Asset.likeUnselected26x23,
            selectedIcon: Asset.likeSelected26x23,
            tintColor: Color.primaryBlue
        )
        var disclosureIndicator: ImageAsset? = Asset.disclosureIndicator
    }
    var style = Style() {
        didSet {
            apply(style: style)
        }
    }
    func apply(style: Style) {
        backgroundColor = style.backgroundColor.uiColor
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.masksToBounds = true
        coverImageView.layer.cornerRadius = style.coverImageCornerRadius
        coverImageView.backgroundColor = style.coverImageBackgroundColor.uiColor
        playButton.apply(style: style.playButton)
        titleLabel.apply(style: style.title)
        artistLabel.apply(style: style.artist)
        yearLabel.apply(style: style.year)
        genresView.style = style.genres
        likeButton.apply(style: style.likeButton)
        disclosureIndicator.image = style.disclosureIndicator?.image
        disclosureIndicator.contentMode = .center
        setNeedsLayout()
    }
    
    // MARK: Properties
    
    private let coverImageView = UIImageView()
    private let playButton = UIButton(type: .system)
    private let infoView = UIView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let yearLabel = UILabel()
    private let genresView = GenresView()
    private let likeButton = UIButton(type: .custom)
    private let disclosureIndicator = UIImageView()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
        apply(style: style)
        
        playButton.rx.tap
            .bind(onNext: { [unowned self] in self.onPlayButtonTap?() })
            .disposed(by: disposeBag)
    }
    
    private func prepareLayout() {
        addSubview(coverImageView)
        addSubview(playButton)
        addSubview(infoView)
        addSubview(likeButton)
        addSubview(disclosureIndicator)
        infoView.addSubview(titleLabel)
        infoView.addSubview(artistLabel)
        infoView.addSubview(yearLabel)
        infoView.addSubview(genresView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    func configure(with album: Album) {
        coverImageView.kf.setImage(with: album.coverImageURL)
        titleLabel.text = album.title
        artistLabel.text = album.artist.name
        yearLabel.text = "2017"
        genresView.text = "Pop, Hip-hop"
        likeButton.isSelected = false
        setNeedsLayout()
    }
    
    var onPlayButtonTap: (() -> Void)?
    
    var viewModel: AlbumCellViewModel {
        return AlbumCellViewModel(
            info: AlbumInfoViewModel(
                year: LabelViewModel(
                    text: yearLabel.text ?? "", font: style.year.font
                )
            )
        )
    }
    
    // MARK: Layout
    
    var makeLayout: ((AlbumCellViewModel, CGRect) -> AlbumViewLayout)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let viewModel = self.viewModel
        
        guard let layout = makeLayout?(viewModel, bounds) else { return }
        
        coverImageView.frame = layout.albumCoverImage
        playButton.frame = layout.playButton
        infoView.frame = layout.infoFrame
        likeButton.frame = layout.likeButton
        disclosureIndicator.frame = layout.disclosureIndicator
        
        titleLabel.frame = layout.info.title
        artistLabel.frame = layout.info.artist
        yearLabel.frame = layout.info.year
        genresView.frame = layout.info.genres
    }
}

struct AlbumViewLayout {
    let albumCoverImage: CGRect
    let playButton: CGRect
    let infoFrame: CGRect
    let info: AlbumInfoLayout
    let likeButton: CGRect
    let disclosureIndicator: CGRect
    
    static let rowHeight = CGFloat(80)
    
    static func makeRowLayout(viewModel: AlbumCellViewModel, bounds: CGRect) -> AlbumViewLayout {
        let albumCoverImage = layout(
            aspectRatio: 1, .v(.v1(top: 8, bottom: 8), and: .leading(16)),
            inBounds: bounds
        )
        var infoFrame = CGRect.zero
        var likeButtonContainer = CGRect.zero
        var disclosureIndicatorContainer = CGRect.zero
        stackRow(
            spacing: 0, [
                StackItem({ _ in }, length: .abs(albumCoverImage.width), leading: 16, trailing: 10),
                StackItem({ infoFrame = $0 }, length: .weight(1), top: 8, bottom: 8, trailing: 0),
                StackItem({ likeButtonContainer = $0 }, length: .abs(44)),
                StackItem({ disclosureIndicatorContainer = $0 }, length: .abs(44)),
                ],
            inFrame: bounds
        )
        let likeButton = layout(
            LayoutRules(
                h: .h1(leading: 8, trailing: -8),
                v: .v4(centerY: .abs(0), height: .abs(44))
            ),
            inFrame: likeButtonContainer
        )
        let disclosureIndicator = layout(
            LayoutRules(
                h: .h1(leading: 0, trailing: 0),
                v: .v4(centerY: .abs(0), height: .abs(44))
            ),
            inFrame: disclosureIndicatorContainer
        )
        
        let info = AlbumInfoLayout.makeRowLayout(viewModel: viewModel.info, bounds: infoFrame.bounds)
        
        return AlbumViewLayout(
            albumCoverImage: albumCoverImage,
            playButton: albumCoverImage,
            infoFrame: infoFrame, info: info,
            likeButton: likeButton,
            disclosureIndicator: disclosureIndicator
        )
    }
    
    static func makeCardLayout(viewModel: AlbumCellViewModel, bounds: CGRect) -> AlbumViewLayout {
        var albumCoverImage = CGRect.zero
        var playButton = CGRect.zero
        var infoFrame = CGRect.zero
        var likeButton = CGRect.zero
        let disclosureIndicator = CGRect.zero
        
        let container = layout(
            LayoutRules(h: .h1(leading: 6, trailing: 6), v: .v1(top: 6, bottom: 6)),
            inBounds: bounds
        )
        stackColumn(
            spacing: 0, [
                StackItem({ albumCoverImage = $0 }, length: .weight(1), bottom: 5),
                StackItem({ infoFrame = $0 }, length: .abs(AlbumInfoLayout.totalHeightForCard))
            ],
            inFrame: container
        )
        let info = AlbumInfoLayout.makeCardLayout(viewModel: viewModel.info, bounds: infoFrame.bounds)
        playButton = layout(
            LayoutRules(
                h: .h4(centerX: .abs(0), width: .abs(44)),
                v: .v4(centerY: .abs(0), height: .abs(44))
            ),
            inFrame: albumCoverImage
        )
        likeButton = layout(
            LayoutRules(
                h: .h3(width: .abs(44), trailing: 0),
                v: .v3(height: .abs(44), bottom: 0)
            ),
            inFrame: albumCoverImage
        )
        
        return AlbumViewLayout(
            albumCoverImage: albumCoverImage,
            playButton: playButton,
            infoFrame: infoFrame, info: info,
            likeButton: likeButton,
            disclosureIndicator: disclosureIndicator
        )
    }
}

struct AlbumInfoLayout {
    let title: CGRect
    let artist: CGRect
    let year: CGRect
    let genres: CGRect
    
    static func makeRowLayout(viewModel: AlbumInfoViewModel, bounds: CGRect) -> AlbumInfoLayout {
        var title = CGRect.zero
        var artist = CGRect.zero
        var yearAndGenres = CGRect.zero
        var year = CGRect.zero
        var genres = CGRect.zero
        
        stackColumn(
            spacing: 4, [
                StackItem({ title = $0 }, length: .weight(1)),
                StackItem({ artist = $0 }, length: .weight(1)),
                StackItem({ yearAndGenres = $0 }, length: .weight(1)),
                ],
            inFrame: bounds
        )
        let text = viewModel.year.boundingRect(width: yearAndGenres.width)
        stackRow(
            spacing: 8, [
                StackItem({ year = $0 }, length: .abs(text.width)),
                StackItem({ genres = $0 }, length: .weight(1)),
                ],
            inFrame: yearAndGenres
        )
        
        return AlbumInfoLayout(
            title: title, artist: artist, year: year, genres: genres
        )
    }
    
    static let totalHeightForCard = CGFloat(60)
    
    static func makeCardLayout(viewModel: AlbumInfoViewModel, bounds: CGRect) -> AlbumInfoLayout {
        var title = CGRect.zero
        var artist = CGRect.zero
        let year = CGRect.zero
        var genres = CGRect.zero
        
        stackColumn(
            spacing: 0, [
                StackItem({ title = $0 }, length: .abs(21), bottom: 1),
                StackItem({ artist = $0 }, length: .abs(16), bottom: 2),
                StackItem({ genres = $0 }, length: .abs(20), leading: 4, trailing: 4)
            ],
            inFrame: bounds
        )
        
        return AlbumInfoLayout(
            title: title, artist: artist, year: year, genres: genres
        )
    }
}
