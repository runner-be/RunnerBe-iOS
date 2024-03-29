// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum AppleSDGothicNeoB00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoB00", family: "AppleSDGothicNeoB00", path: "AppleSDGothicNeoB.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoEB00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoEB00", family: "AppleSDGothicNeoEB00", path: "AppleSDGothicNeoEB.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoH00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoH00", family: "AppleSDGothicNeoH00", path: "AppleSDGothicNeoH.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoL00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoL00", family: "AppleSDGothicNeoL00", path: "AppleSDGothicNeoL.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoM00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoM00", family: "AppleSDGothicNeoM00", path: "AppleSDGothicNeoM.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoR00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoR00", family: "AppleSDGothicNeoR00", path: "AppleSDGothicNeoR.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoSB00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoSB00", family: "AppleSDGothicNeoSB00", path: "AppleSDGothicNeoSB.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoT00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoT00", family: "AppleSDGothicNeoT00", path: "AppleSDGothicNeoT.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum AppleSDGothicNeoUL00 {
    internal static let regular = FontConvertible(name: "AppleSDGothicNeoUL00", family: "AppleSDGothicNeoUL00", path: "AppleSDGothicNeoUL.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum Pretendard {
    internal static let bold = FontConvertible(name: "Pretendard-Bold", family: "Pretendard", path: "Pretendard-Bold.otf")
    internal static let extraBold = FontConvertible(name: "Pretendard-ExtraBold", family: "Pretendard", path: "Pretendard-ExtraBold.otf")
    internal static let light = FontConvertible(name: "Pretendard-Light", family: "Pretendard", path: "Pretendard-Light.otf")
    internal static let medium = FontConvertible(name: "Pretendard-Medium", family: "Pretendard", path: "Pretendard-Medium.otf")
    internal static let regular = FontConvertible(name: "Pretendard-Regular", family: "Pretendard", path: "Pretendard-Regular.otf")
    internal static let semiBold = FontConvertible(name: "Pretendard-SemiBold", family: "Pretendard", path: "Pretendard-SemiBold.otf")
    internal static let all: [FontConvertible] = [bold, extraBold, light, medium, regular, semiBold]
  }
  internal enum SBAggroOTF {
    internal static let bold = FontConvertible(name: "OTSBAggroB", family: "SB AggroOTF", path: "SBAggroOTFB.otf")
    internal static let light = FontConvertible(name: "OTSBAggroL", family: "SB AggroOTF", path: "SBAggroOTFL.otf")
    internal static let medium = FontConvertible(name: "OTSBAggroM", family: "SB AggroOTF", path: "SBAggroOTFM.otf")
    internal static let all: [FontConvertible] = [bold, light, medium]
  }
  internal static let allCustomFonts: [FontConvertible] = [AppleSDGothicNeoB00.all, AppleSDGothicNeoEB00.all, AppleSDGothicNeoH00.all, AppleSDGothicNeoL00.all, AppleSDGothicNeoM00.all, AppleSDGothicNeoR00.all, AppleSDGothicNeoSB00.all, AppleSDGothicNeoT00.all, AppleSDGothicNeoUL00.all, Pretendard.all, SBAggroOTF.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
