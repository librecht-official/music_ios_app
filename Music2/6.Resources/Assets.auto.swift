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
  internal static let back12x20 = ImageAsset(name: "back12x20")
  internal static let disclosureIndicator = ImageAsset(name: "disclosureIndicator")
  internal static let fastBackward44x44 = ImageAsset(name: "fastBackward44x44")
  internal static let fastForward44x44 = ImageAsset(name: "fastForward44x44")
  internal static let like2Selected34x31 = ImageAsset(name: "like2Selected34x31")
  internal static let like2Unselected34x31 = ImageAsset(name: "like2Unselected34x31")
  internal static let likeSelected26x23 = ImageAsset(name: "likeSelected26x23")
  internal static let likeUnselected26x23 = ImageAsset(name: "likeUnselected26x23")
  internal static let maxVolume20x16 = ImageAsset(name: "maxVolume20x16")
  internal static let minVolume20x16 = ImageAsset(name: "minVolume20x16")
  internal static let musicAlbumPlaceholder122x120 = ImageAsset(name: "musicAlbumPlaceholder122x120")
  internal static let pause44x44 = ImageAsset(name: "pause44x44")
  internal static let play44x44 = ImageAsset(name: "play44x44")
  internal static let playWhite39x40 = ImageAsset(name: "playWhite39x40")
  internal static let playedProgress = ImageAsset(name: "playedProgress")
  internal static let profileMock = ImageAsset(name: "profile_mock")
  internal static let progressBackground = ImageAsset(name: "progressBackground")
  internal static let progressBackground2 = ImageAsset(name: "progressBackground2")
  internal static let progressBackground3 = ImageAsset(name: "progressBackground3")
  internal static let progressThumb = ImageAsset(name: "progressThumb")
  internal static let remaingingProgress3 = ImageAsset(name: "remaingingProgress3")
  internal static let remainingProgress = ImageAsset(name: "remainingProgress")
  internal static let remainingProgress2 = ImageAsset(name: "remainingProgress2")
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
