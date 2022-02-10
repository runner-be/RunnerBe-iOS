// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Birth {
    /// 정확한 나이는 공개되지 않아요!
    internal static let subTitle1 = L10n.tr("Localizable", "Birth.subTitle1")
    /// 20대 초반, 30대 중반 등으로 표기될 거에요.
    internal static let subTitle2 = L10n.tr("Localizable", "Birth.subTitle2")
    /// 출생년도를 입력해주세요.
    internal static let title = L10n.tr("Localizable", "Birth.title")
    internal enum NavBar {
      /// TITLE
      internal static let title = L10n.tr("Localizable", "Birth.NavBar.title")
    }
    internal enum Button {
      /// 다음
      internal static let next = L10n.tr("Localizable", "Birth.button.next")
    }
    internal enum Error {
      /// 19세 미만은 이용할 수 없어요!
      internal static let age = L10n.tr("Localizable", "Birth.error.age")
    }
  }

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

  internal enum PhotoCertification {
    /// 해당 정보는 러너님이 직장인임을 확인하는 용도로만
    internal static let subTitle1 = L10n.tr("Localizable", "PhotoCertification.subTitle1")
    /// 사용되며, 인증 후 안전하게 폐기됩니다.
    internal static let subTitle2 = L10n.tr("Localizable", "PhotoCertification.subTitle2")
    /// 사진(ex. 사원증, 명함)으로
    internal static let title1 = L10n.tr("Localizable", "PhotoCertification.title1")
    /// 직업을 인증해주세요!
    internal static let title2 = L10n.tr("Localizable", "PhotoCertification.title2")
    internal enum Button {
      internal enum Certificate {
        /// 인증하기
        internal static let title = L10n.tr("Localizable", "PhotoCertification.Button.Certificate.title")
      }
    }
    internal enum ImageRule {
      /// 👉
      internal static let emoji = L10n.tr("Localizable", "PhotoCertification.ImageRule.emoji")
      /// 정보를 식별할 수 있어야 해요
      internal static let no2 = L10n.tr("Localizable", "PhotoCertification.ImageRule.no2")
      /// 개인정보 보호를 위해 다른 정보는 가려주세요
      internal static let no3 = L10n.tr("Localizable", "PhotoCertification.ImageRule.no3")
      internal enum No1 {
        /// 직장명, 직무/직위
        internal static let highlighted = L10n.tr("Localizable", "PhotoCertification.ImageRule.no1.highlighted")
        /// 는 꼭 드러나야 해요!
        internal static let normal = L10n.tr("Localizable", "PhotoCertification.ImageRule.no1.normal")
      }
    }
    internal enum Modal {
      /// 인증 확인까지 최대 6시간 정도가
      internal static let title1 = L10n.tr("Localizable", "PhotoCertification.Modal.title1")
      /// 소요될 수 있어요!
      internal static let title2 = L10n.tr("Localizable", "PhotoCertification.Modal.title2")
      internal enum Button {
        /// 촬영하기
        internal static let _1 = L10n.tr("Localizable", "PhotoCertification.Modal.Button.1")
        /// 앨범에서 선택하기
        internal static let _2 = L10n.tr("Localizable", "PhotoCertification.Modal.Button.2")
      }
    }
    internal enum NavBar {
      /// TITLE
      internal static let title = L10n.tr("Localizable", "PhotoCertification.NavBar.title")
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

  internal enum SelectGender {
    /// 성별을 선택해주세요.
    internal static let title = L10n.tr("Localizable", "SelectGender.title")
    internal enum Button {
      internal enum Next {
        /// 다음
        internal static let title = L10n.tr("Localizable", "SelectGender.Button.Next.title")
      }
    }
    internal enum Gender {
      /// 여성
      internal static let female = L10n.tr("Localizable", "SelectGender.Gender.female")
      /// 남성
      internal static let male = L10n.tr("Localizable", "SelectGender.Gender.male")
    }
    internal enum NavBar {
      /// TITLE
      internal static let title = L10n.tr("Localizable", "SelectGender.NavBar.title")
    }
  }

  internal enum SelectJobGroup {
    /// 추후 마이페이지에서 수정할 수 있어요!
    internal static let subTitle = L10n.tr("Localizable", "SelectJobGroup.subTitle")
    /// 어떤 직군에서
    internal static let title1 = L10n.tr("Localizable", "SelectJobGroup.title1")
    /// 활동하시나요?
    internal static let title2 = L10n.tr("Localizable", "SelectJobGroup.title2")
    internal enum Button {
      internal enum Next {
        /// 다음
        internal static let title = L10n.tr("Localizable", "SelectJobGroup.Button.Next.title")
      }
    }
    internal enum Group {
      /// 공무원
      internal static let _1 = L10n.tr("Localizable", "SelectJobGroup.Group.1")
      /// 영업/제휴
      internal static let _10 = L10n.tr("Localizable", "SelectJobGroup.Group.10")
      /// 의료
      internal static let _11 = L10n.tr("Localizable", "SelectJobGroup.Group.11")
      /// 인사
      internal static let _12 = L10n.tr("Localizable", "SelectJobGroup.Group.12")
      /// 재무/회계
      internal static let _13 = L10n.tr("Localizable", "SelectJobGroup.Group.13")
      /// CS
      internal static let _14 = L10n.tr("Localizable", "SelectJobGroup.Group.14")
      /// 교육
      internal static let _2 = L10n.tr("Localizable", "SelectJobGroup.Group.2")
      /// 개발
      internal static let _3 = L10n.tr("Localizable", "SelectJobGroup.Group.3")
      /// 기획/전략/경영
      internal static let _4 = L10n.tr("Localizable", "SelectJobGroup.Group.4")
      /// 디자인
      internal static let _5 = L10n.tr("Localizable", "SelectJobGroup.Group.5")
      /// 마케팅/PR
      internal static let _6 = L10n.tr("Localizable", "SelectJobGroup.Group.6")
      /// 서비스
      internal static let _7 = L10n.tr("Localizable", "SelectJobGroup.Group.7")
      /// 생산
      internal static let _8 = L10n.tr("Localizable", "SelectJobGroup.Group.8")
      /// 연구
      internal static let _9 = L10n.tr("Localizable", "SelectJobGroup.Group.9")
    }
    internal enum NavBar {
      /// TITLE
      internal static let title = L10n.tr("Localizable", "SelectJobGroup.NavBar.title")
    }
  }

  internal enum EmailCertification {
    /// 해당 정보는 러너님이 직장임을 확인하는 용도로만
    internal static let subTitle1 = L10n.tr("Localizable", "emailCertification.subTitle1")
    /// 사용되며, 외부에 공개되지 않습니다.
    internal static let subTitle2 = L10n.tr("Localizable", "emailCertification.subTitle2")
    /// 회사 이메일로
    internal static let title1 = L10n.tr("Localizable", "emailCertification.title1")
    /// 직장을 인증해주세요
    internal static let title2 = L10n.tr("Localizable", "emailCertification.title2")
    internal enum Button {
      internal enum Certificate {
        /// 인증하기
        internal static let firstSend = L10n.tr("Localizable", "emailCertification.Button.Certificate.firstSend")
        /// 재전송
        internal static let resend = L10n.tr("Localizable", "emailCertification.Button.Certificate.resend")
      }
      internal enum NotHaveEmail {
        /// 회사 이메일이 없어요
        internal static let title = L10n.tr("Localizable", "emailCertification.Button.NotHaveEmail.title")
      }
    }
    internal enum Message {
      /// 인증 링크가 발송되었어요
      internal static let mailSend1 = L10n.tr("Localizable", "emailCertification.Message.MailSend1")
      /// 메일이 오지 않는다면 스팸 메일함도 확인해주세요!
      internal static let mailSend2 = L10n.tr("Localizable", "emailCertification.Message.MailSend2")
    }
    internal enum NavBar {
      /// TITLE
      internal static let title = L10n.tr("Localizable", "emailCertification.NavBar.title")
    }
    internal enum EmailField {
      /// runnerbee@company.com
      internal static let placeholder = L10n.tr("Localizable", "emailCertification.emailField.placeholder")
    }
    internal enum Error {
      /// 이미 사용 중인 이메일이에요!
      internal static let duplicated = L10n.tr("Localizable", "emailCertification.error.duplicated")
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
