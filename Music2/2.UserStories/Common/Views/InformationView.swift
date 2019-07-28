//
//  InformationView.swift
//  Music2
//
//  Created by Vladislav Librecht on 03.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Layout

// MARK: - InformationViewModel

struct InformationViewModel {
    let icon: ImageAsset
    let message: String
    
    static let nothingHere = InformationViewModel(
        icon: Asset.musicAlbumPlaceholder122x120, message: L10n.Explore.nothingHere
    )
}

// MARK: - InformationView

final class InformationView: UIView {
    // MARK: Style
    
    struct Style {
        let imageTint = Color.black
        let message = LabelStyle(
            font: Font.semibold(22), textColor: Color.blackText, alignment: .center
        )
    }
    var style = Style() { didSet { apply(style: style) } }
    func apply(style: Style) {
        imageView.alpha = 0.5
        imageView.tintColor = style.imageTint.uiColor
        messageLabel.apply(style: style.message)
    }
    
    // MARK: ViewModel
    
    var viewModel: InformationViewModel { didSet { setNeedsLayout() } }
    
   // MARK: Properties
    
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    
    init(viewModel: InformationViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(messageLabel)
        apply(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.image = viewModel.icon.image.template
        messageLabel.text = viewModel.message
        
        let imageSize = viewModel.icon.image.size
        let imageWidth = imageSize.width
        let aspect = imageSize.height != 0 ? imageWidth / imageSize.height : 1
        imageView.frame = layout(
            aspectRatio: aspect,
            .h(.h4(centerX: .abs(0), width: .abs(imageWidth)), and: .centerY(.rel(0.8))),
            inBounds: bounds
        )
        var messageContainer = layout(
            LayoutRules(
                h: .h1(leading: 16, trailing: 16),
                v: .v1(top: imageView.frame.maxY + 32, bottom: 20)),
            inBounds: bounds
        )
        let vm = LabelViewModel(text: viewModel.message, font: style.message.font)
        messageContainer.size.height = vm.boundingRect(width: messageContainer.width).height
        messageLabel.frame = messageContainer
    }
}

extension UIImageView: SizeAware {}

// MARK: - InformationViewController

final class InformationViewController: UIViewController {
    var viewModel: InformationViewModel {
        get { return informationView.viewModel }
        set { informationView.viewModel = newValue }
    }
    private let informationView: InformationView
    
    init(viewModel: InformationViewModel) {
        self.informationView = InformationView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = informationView
    }
}
