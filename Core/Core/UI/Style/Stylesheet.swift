//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import UIKit


public typealias Style<V: UIView> = (V) -> ()
public typealias Color = UIColor

public protocol StylesheetType {
    var color: ColorStylesheetType { get }
    var image: ImageStylesheetType { get }
    var shadow: ShadowStylesheetType { get }
    var cornerRadius: CornerRadiusStylesheetType { get }
    var view: ViewStylesheetType { get }
    var text: TextStylesheetType { get }
    var button: ButtonStylesheetType { get }
}

public protocol ColorStylesheetType {
    var background: Color { get }
    var blackControl: Color { get }
    
    var gray1: Color { get }
    var lightGray1: Color { get }
    
    var primaryTint: Color { get }
    var primaryText: Color { get }
    var primaryWhiteText: Color { get }
    
    var metalicGradient: [Color] { get }
}

public protocol ImageStylesheetType {
    var musicAlbumPlaceholderLarge: UIImage { get }
    var minVolume: UIImage { get }
    var maxVolume: UIImage { get }
    var playbackProgressBackground: UIImage { get }
    
    // TODO: remove
    var profileStub: UIImage { get }
}

public protocol ShadowStylesheetType {
    var card: Style<UIView> { get }
}

public protocol CornerRadiusStylesheetType {
    /// 4
    var small: Style<UIView> { get }
    /// 8
    var normal: Style<UIView> { get }
    /// 20
    var large: Style<UIView> { get }
}

public protocol ViewStylesheetType {
    var background: Style<UIView> { get }
    var primaryTinted: Style<UIView> { get }
    var grayRounded: Style<UIView> { get }
}

public protocol TextStylesheetType {
    var majorTitle2: Style<UILabel> { get }
    var majorTitle3: Style<UILabel> { get }
    var title3: Style<UILabel> { get }
    var headline: Style<UILabel> { get }
    var body: Style<UILabel> { get }
    var smallBody: Style<UILabel> { get }
    var minorFootnote: Style<UILabel> { get }
    var whiteCaption1: Style<UILabel> { get }
}

public protocol ButtonStylesheetType {
    var smallText: Style<UIButton> { get }
    var lightPlay: Style<UIButton> { get }
    var play: Style<UIButton> { get }
    var fastForward: Style<UIButton> { get }
    var fastBackward: Style<UIButton> { get }
    var like: Style<UIButton> { get }
    var likeTextured: Style<UIButton> { get }
}

// MARK: - Access

private var _stylesheet: StylesheetType?

public func load(stylesheet: StylesheetType) {
    _stylesheet = stylesheet
}

public func stylesheet() -> StylesheetType {
    guard let res = _stylesheet else {
        fatalError("You must register stylesheet using load(stylesheet:)")
    }
    return res
}
