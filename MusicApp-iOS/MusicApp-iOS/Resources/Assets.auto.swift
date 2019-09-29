// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {

    internal static let action1 = ColorAsset(name: "Colors/action1")
    internal static let background = ColorAsset(name: "Colors/background")
    internal static let blackControl = ColorAsset(name: "Colors/blackControl")
    internal static let gray1 = ColorAsset(name: "Colors/gray1")
    internal static let metalicGray1 = ColorAsset(name: "Colors/metalicGray1")
    internal static let metalicGray2 = ColorAsset(name: "Colors/metalicGray2")
    internal static let shadowGray1 = ColorAsset(name: "Colors/shadowGray1")
    internal static let text1 = ColorAsset(name: "Colors/text1")
    internal static let text3 = ColorAsset(name: "Colors/text3")
    internal static let whiteControl = ColorAsset(name: "Colors/whiteControl")
    internal static let whiteText1 = ColorAsset(name: "Colors/whiteText1")
  }
  internal enum Images {

    internal static let fastBackward44x44 = ImageAsset(name: "Images/fastBackward44x44")
    internal static let fastForward44x44 = ImageAsset(name: "Images/fastForward44x44")
    internal static let likeFilled26x23 = ImageAsset(name: "Images/likeFilled_26x23")
    internal static let likeTexturedFilled34x31 = ImageAsset(name: "Images/likeTexturedFilled_34x31")
    internal static let likeTextured34x31 = ImageAsset(name: "Images/likeTextured_34x31")
    internal static let like26x23 = ImageAsset(name: "Images/like_26x23")
    internal static let maxVolume20x16 = ImageAsset(name: "Images/maxVolume20x16")
    internal static let minVolume20x16 = ImageAsset(name: "Images/minVolume20x16")
    internal static let musicAlbumPlaceholder195x191 = ImageAsset(name: "Images/musicAlbumPlaceholder_195x191")
    internal static let pause44x44 = ImageAsset(name: "Images/pause_44x44")
    internal static let play44x44 = ImageAsset(name: "Images/play_44x44")
    internal static let profileStub = ImageAsset(name: "Images/profile_stub")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
