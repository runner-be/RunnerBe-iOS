// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let _2 = ImageAsset(name: "2")
  internal static let alarmNew = ImageAsset(name: "Alarm_New")
  internal static let alarmNomal = ImageAsset(name: "Alarm_Nomal")
  internal static let appleLogin = ImageAsset(name: "Apple_login")
  internal static let applicant = ImageAsset(name: "Applicant")
  internal static let arrowLeft = ImageAsset(name: "Arrow_Left")
  internal static let bigBookmarkNormal = ImageAsset(name: "BigBookmarkNormal")
  internal static let bigBookmarkSelected = ImageAsset(name: "BigBookmarkSelected")
  internal static let bookmarkTabIconFocused = ImageAsset(name: "BookmarkTabIcon_focused")
  internal static let bookmarkTabIconNormal = ImageAsset(name: "BookmarkTabIcon_normal")
  internal static let camera = ImageAsset(name: "Camera")
  internal static let checkBoxIconChecked = ImageAsset(name: "CheckBoxIcon_Checked")
  internal static let chevronDown = ImageAsset(name: "Chevron_down")
  internal static let chevronRight = ImageAsset(name: "Chevron_right")
  internal static let chevronRightXs = ImageAsset(name: "Chevron_right_Xs")
  internal static let circleInfo = ImageAsset(name: "Circle_info")
  internal static let filter = ImageAsset(name: "Filter")
  internal static let filterActive = ImageAsset(name: "FilterActive")
  internal static let filterHighlighted = ImageAsset(name: "FilterHighlighted")
  internal static let floatingButton = ImageAsset(name: "FloatingButton")
  internal static let group = ImageAsset(name: "Group")
  internal static let homeLocation = ImageAsset(name: "HomeLocation")
  internal static let homeTabIconFocused = ImageAsset(name: "HomeTabIcon_Focused")
  internal static let homeTabIconNormal = ImageAsset(name: "HomeTabIcon_normal")
  internal static let kakaoLogin = ImageAsset(name: "Kakao_login")
  internal static let lockLocked = ImageAsset(name: "Lock_locked")
  internal static let logo = ImageAsset(name: "Logo")
  internal static let logoSignature = ImageAsset(name: "Logo_signature")
  internal static let messageActive = ImageAsset(name: "MessageActive")
  internal static let messageInactive = ImageAsset(name: "MessageInactive")
  internal static let messageTabIconFocused = ImageAsset(name: "MessageTabIcon_Focused")
  internal static let messageTabIconNormal = ImageAsset(name: "MessageTabIcon_normal")
  internal static let minus = ImageAsset(name: "Minus")
  internal static let moreVertical = ImageAsset(name: "MoreVertical")
  internal static let myPageTabIconFocused = ImageAsset(name: "MyPageTabIcon_focused")
  internal static let myPageTabIconNormal = ImageAsset(name: "MyPageTabIcon_normal")
  internal static let myPageRegistserRunningPaceWordbubble = ImageAsset(name: "MyPage_RegistserRunningPace_Wordbubble")
  internal static let naverLogin = ImageAsset(name: "Naver_login")
  internal static let onboardingCompletion = ImageAsset(name: "OnboardingCompletion")
  internal static let place = ImageAsset(name: "Place")
  internal static let placeImage = ImageAsset(name: "PlaceImage")
  internal static let placeActive = ImageAsset(name: "Place_Active")
  internal static let placeActiveSelected = ImageAsset(name: "Place_Active_Selected")
  internal static let placeInactive = ImageAsset(name: "Place_Inactive")
  internal static let placeInactiveSelected = ImageAsset(name: "Place_Inactive_Selected")
  internal static let plus = ImageAsset(name: "Plus")
  internal static let plusDarkG4 = ImageAsset(name: "PlusDarkG4")
  internal static let postEmptyGuideBackground = ImageAsset(name: "PostEmptyGuideBackground")
  internal static let postOwner = ImageAsset(name: "PostOwner")
  internal static let profileEmptyIcon = ImageAsset(name: "ProfileEmptyIcon")
  internal static let profileWithCam = ImageAsset(name: "ProfileWithCam")
  internal static let refresh = ImageAsset(name: "Refresh")
  internal static let registerRunningPaceCheckboxOff = ImageAsset(name: "Register_RunningPace_checkbox_off")
  internal static let registerRunningPaceCheckboxOn = ImageAsset(name: "Register_RunningPace_checkbox_on")
  internal static let registerRunningPaceCheckboxOnDisable = ImageAsset(name: "Register_RunningPace_checkbox_on_disable")
  internal static let registerRunningPaceRadioOff = ImageAsset(name: "Register_RunningPace_radio_off")
  internal static let registerRunningPaceRadioOn = ImageAsset(name: "Register_RunningPace_radio_on")
  internal static let report = ImageAsset(name: "Report")
  internal static let runnerBeJudy = ImageAsset(name: "RunnerBeJudy")
  internal static let runnerBeNiaka = ImageAsset(name: "RunnerBeNiaka")
  internal static let runnerBeSiv = ImageAsset(name: "RunnerBeSiv")
  internal static let runnerBeZoe = ImageAsset(name: "RunnerBeZoe")
  internal static let runnerBeDESIGN = ImageAsset(name: "RunnerBe_DESIGN")
  internal static let runnerBePLAN = ImageAsset(name: "RunnerBe_PLAN")
  internal static let runnerBeServer = ImageAsset(name: "RunnerBe_Server")
  internal static let runningPaceAverage = ImageAsset(name: "RunningPace_Average")
  internal static let runningPaceBeginner = ImageAsset(name: "RunningPace_Beginner")
  internal static let runningPaceHigh = ImageAsset(name: "RunningPace_High")
  internal static let runningPaceMaster = ImageAsset(name: "RunningPace_Master")
  internal static let scheduled = ImageAsset(name: "Scheduled")
  internal static let search = ImageAsset(name: "Search")
  internal static let settings = ImageAsset(name: "Settings")
  internal static let smile = ImageAsset(name: "Smile")
  internal static let time = ImageAsset(name: "Time")
  internal static let upload = ImageAsset(name: "Upload")
  internal static let whiteCircleBackground = ImageAsset(name: "WhiteCircle_Background")
  internal static let writePostRunningPaceWordbubble = ImageAsset(name: "WritePost_RunningPace_Wordbubble")
  internal static let x = ImageAsset(name: "X")
  internal static let checkBoxIconEmpty = ImageAsset(name: "checkBoxIconEmpty")
  internal static let chevronDownNew = ImageAsset(name: "chevron_down_new")
  internal static let circleCancelBlack = ImageAsset(name: "circle-cancel-black")
  internal static let icBadRunner = ImageAsset(name: "icBadRunner")
  internal static let icBasicRunner = ImageAsset(name: "icBasicRunner")
  internal static let icEffortRunner = ImageAsset(name: "icEffortRunner")
  internal static let icGoodRunner = ImageAsset(name: "icGoodRunner")
  internal static let iconEmpty72 = ImageAsset(name: "iconEmpty72")
  internal static let iconLocation18 = ImageAsset(name: "iconLocation18")
  internal static let iconSearch18 = ImageAsset(name: "iconSearch18")
  internal static let iconWarning20 = ImageAsset(name: "iconWarning20")
  internal static let iconsPlus18 = ImageAsset(name: "iconsPlus18")
  internal static let iconsProfile48 = ImageAsset(name: "iconsProfile48")
  internal static let iconsReport24 = ImageAsset(name: "iconsReport24")
  internal static let iconsSend24 = ImageAsset(name: "iconsSend24")
  internal static let iconsSendFilled24 = ImageAsset(name: "iconsSendFilled24")
  internal static let iconsWriter24 = ImageAsset(name: "iconsWriter24")
  internal static let vDivider = ImageAsset(name: "vDivider")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
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
