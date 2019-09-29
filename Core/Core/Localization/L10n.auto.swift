// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum L10n {

  public enum Explore {
    /// Nothing here for now :(
    public static let nothingHere = L10n.tr("Localizable", "Explore.NothingHere")
    public enum Section {
      /// Popular
      public static let popular = L10n.tr("Localizable", "Explore.Section.Popular")
      /// Recommended to you
      public static let recommendations = L10n.tr("Localizable", "Explore.Section.Recommendations")
      /// Trending
      public static let trending = L10n.tr("Localizable", "Explore.Section.Trending")
    }
  }

  public enum Main {
    public enum Tab {
      /// Explore
      public static let explore = L10n.tr("Localizable", "Main.Tab.Explore")
      /// Favorites
      public static let favorites = L10n.tr("Localizable", "Main.Tab.Favorites")
      /// Playlists
      public static let playlists = L10n.tr("Localizable", "Main.Tab.Playlists")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
