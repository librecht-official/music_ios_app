//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit
import Core


typealias Color = Asset.Colors
typealias Image = Asset.Images

final class AppStylesheet: StylesheetType {
    let color: ColorStylesheetType = ColorStylesheet()
    let image: ImageStylesheetType = ImageStylesheet()
    let shadow: ShadowStylesheetType = ShadowStylesheet()
    let cornerRadius: CornerRadiusStylesheetType = CornerRadiusStylesheet()
    let view: ViewStylesheetType = ViewStylesheet()
    let text: TextStylesheetType = TextStylesheet()
    let button: ButtonStylesheetType = ButtonStylesheet()
}

// MARK: - Color

final class ColorStylesheet: ColorStylesheetType {
    let background = Color.background.color
    let blackControl = Color.blackControl.color
    let gray1 = Color.gray1.color
    let metalicGradient = [Color.metalicGray1.color, Color.metalicGray2.color]
    let primaryTint = Color.action1.color
    let primaryText = Color.text1.color
    let primaryWhiteText = Color.whiteText1.color
}

// MARK: - Image

final class ImageStylesheet: ImageStylesheetType {
    var musicAlbumPlaceholderLarge: UIImage {
        Image.musicAlbumPlaceholder195x191.image
    }
    
    var minVolume: UIImage { Image.minVolume20x16.image }
    var maxVolume: UIImage { Image.maxVolume20x16.image }
    
    var profileStub: UIImage {
        Image.profileStub.image
    }
}

// MARK: - Shadow

final class ShadowStylesheet: ShadowStylesheetType {
    let card: Style<UIView> = { view in
        view.layer.shadowColor = Color.shadowGray1.color.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
    }
}

// MARK: - Corner Radius

final class CornerRadiusStylesheet: CornerRadiusStylesheetType {
    let small: Style<UIView> = smallCornerRadius
    let normal: Style<UIView> = normalCornerRadius
    let large: Style<UIView> = largeCornerRadius
}

private let smallCornerRadius: Style<UIView> = { view in
    view.layer.cornerRadius = 4
    view.layer.masksToBounds = true
}
private let normalCornerRadius: Style<UIView> = { view in
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
}
private let largeCornerRadius: Style<UIView> = { view in
    view.layer.cornerRadius = 20
    view.layer.masksToBounds = true
}

// MARK: - View

final class ViewStylesheet: ViewStylesheetType {
    let background: Style<UIView> = { view in
        view.backgroundColor = Color.background.color
    }
    
    let primaryTinted: Style<UIView> = { view in
        view.tintColor = Color.action1.color
    }
    
    let grayRounded: Style<UIView> = { view in
        smallCornerRadius(view)
        view.backgroundColor = Color.gray1.color
    }
}

// MARK: - Text

final class TextStylesheet: TextStylesheetType {
    let majorTitle2: Style<UILabel> = { label in
        dynamicTypeBoldTextStyle(.title2)(label)
        label.textColor = Color.text1.color
    }
    
    let majorTitle3: Style<UILabel> = { label in
        dynamicTypeBoldTextStyle(.title3)(label)
        label.textColor = Color.text1.color
    }
    
    let title3: Style<UILabel> = { label in
        dynamicTypeTextStyle(.title3)(label)
        label.textColor = Color.text1.color
    }
    
    let headline: Style<UILabel> = { label in
        dynamicTypeTextStyle(.headline)(label)
        label.textColor = Color.text1.color
    }
    
    let body: Style<UILabel> = { label in
        dynamicTypeTextStyle(.body)(label)
        label.textColor = Color.text1.color
    }
    
    let smallBody: Style<UILabel> = { label in
        dynamicTypeTextStyle(.subheadline)(label)
        label.textColor = Color.text1.color
    }
    
    let minorFootnote: Style<UILabel> = { label in
        dynamicTypeTextStyle(.footnote)(label)
        label.textColor = Color.text3.color
    }
    
    let whiteCaption1: Style<UILabel> = { label in
        dynamicTypeTextStyle(.caption1)(label)
        label.textColor = Color.whiteText1.color
    }
}
/*
    UIFont.TextStyle fonts:

    .largeTitle       SFUIDisplay         34.0
    .title1           SFUIDisplay         28.0
    .title2           SFUIDisplay         22.0
    .title3           SFUIDisplay         20.0
    .headline         SFUIText-Semibold   17.0
    .callout          SFUIText            16.0
    .subheadline      SFUIText            15.0
    .body             SFUIText            17.0
    .footnote         SFUIText            13.0
    .caption1         SFUIText            12.0
    .caption2         SFUIText            11.0
*/
func dynamicTypeTextStyle(_ style: UIFont.TextStyle) -> Style<UILabel> {
    return { label in
        label.font = UIFont.preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
    }
}
func dynamicTypeBoldTextStyle(_ style: UIFont.TextStyle) -> Style<UILabel> {
    return { label in
        label.font = UIFont.preferredFont(forTextStyle: style).bold()
        label.adjustsFontForContentSizeCategory = true
    }
}

// MARK: - Button

final class ButtonStylesheet: ButtonStylesheetType {
    let smallText: Style<UIButton> = { button in
        button.tintColor = Color.action1.color
        button.setTitleColor(Color.action1.color, for: .normal)
        button.titleLabel.map(dynamicTypeTextStyle(.subheadline))
    }
    
    let lightPlay: Style<UIButton> = { button in
        button.alpha = 0.85
        button.tintColor = Color.whiteControl.color
        button.setImage(Image.play44x44.image.template, for: .normal)
        button.setImage(Image.pause44x44.image.template, for: .selected)
    }
    
    let play: Style<UIButton> = { button in
        button.tintColor = Color.blackControl.color
        button.setImage(Image.play44x44.image.template, for: .normal)
        button.setImage(Image.pause44x44.image.template, for: .selected)
    }
    
    let fastForward: Style<UIButton> = { button in
        button.tintColor = Color.blackControl.color
        button.setImage(Image.fastForward44x44.image.template, for: .normal)
    }
    
    let fastBackward: Style<UIButton> = { button in
        button.tintColor = Color.blackControl.color
        button.setImage(Image.fastBackward44x44.image.template, for: .normal)
    }
    
    let like: Style<UIButton> = { button in
        button.tintColor = Color.action1.color
        button.setImage(Image.like26x23.image, for: .normal)
        button.setImage(Image.likeFilled26x23.image, for: .selected)
    }
    
    let likeTextured: Style<UIButton> = { button in
        button.tintColor = Color.action1.color
        button.setImage(Image.likeTextured34x31.image, for: .normal)
        button.setImage(Image.likeTexturedFilled34x31.image, for: .selected)
    }
}
