// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum LoggedOut {
    internal enum AppleBtn {
      /// Login with Apple
      internal static let text = L10n.tr("Localizable", "LoggedOut.AppleBtn.text")
    }
    internal enum KakaoBtn {
      /// Login with Kakao
      internal static let text = L10n.tr("Localizable", "LoggedOut.KakaoBtn.text")
    }
    internal enum NaverBtn {
      /// Login with Naver
      internal static let text = L10n.tr("Localizable", "LoggedOut.NaverBtn.text")
    }
  }

  internal enum MainTabbar {
    internal enum Item {
      internal enum BookMark {
        /// BookMark
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.BookMark.title")
      }
      internal enum Home {
        /// Home
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.Home.title")
      }
      internal enum Message {
        /// Message
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.Message.title")
      }
      internal enum MyPage {
        /// MyPage
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.MyPage.title")
      }
    }
  }

  internal enum NickName {
    /// 한 번 정한 닉네임은 수정할 수 없어요.
    internal static let subtitle = L10n.tr("Localizable", "NickName.subtitle")
    /// 어떤 닉네임으로
    internal static let title1 = L10n.tr("Localizable", "NickName.title1")
    /// 활동하실 건가요?
    internal static let title2 = L10n.tr("Localizable", "NickName.title2")
    internal enum Button {
      internal enum CheckDup {
        /// 중복 확인
        internal static let title = L10n.tr("Localizable", "NickName.button.checkDup.title")
      }
      internal enum SetNickname {
        /// 정했어요!
        internal static let title = L10n.tr("Localizable", "NickName.button.setNickname.title")
      }
    }
    internal enum Error {
      /// 중복된 닉네임이에요!
      internal static let duplicated = L10n.tr("Localizable", "NickName.error.duplicated")
      /// 특수문자, 띄어쓰기는 쓸 수 없어요!
      internal static let textformat = L10n.tr("Localizable", "NickName.error.textformat")
    }
    internal enum Textfield {
      /// 영어 8자/한글 6자까지 쓸 수 있어요.
      internal static let placeholder = L10n.tr("Localizable", "NickName.textfield.placeholder")
    }
  }

  internal enum PolicyTerm {
    /// 먼저 이용약관을 읽고
    internal static let title1 = L10n.tr("Localizable", "PolicyTerm.title1")
    /// 동의해주세요!
    internal static let title2 = L10n.tr("Localizable", "PolicyTerm.title2")
    internal enum Agree {
      internal enum All {
        /// 모든 약관을 읽었으며, 이에 동의해요
        internal static let title = L10n.tr("Localizable", "PolicyTerm.Agree.All.title")
      }
      internal enum Location {
        /// [필수] 위치기반 서비스 이용약관 동의
        internal static let title = L10n.tr("Localizable", "PolicyTerm.Agree.Location.title")
      }
      internal enum Privacy {
        /// [필수] 개인정보 수집/이용 동의
        internal static let title = L10n.tr("Localizable", "PolicyTerm.Agree.Privacy.title")
      }
      internal enum Service {
        /// [필수] 서비스 이용약관 동의
        internal static let title = L10n.tr("Localizable", "PolicyTerm.Agree.Service.title")
      }
    }
    internal enum Button {
      internal enum Next {
        /// 다음
        internal static let title = L10n.tr("Localizable", "PolicyTerm.Button.Next.title")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
