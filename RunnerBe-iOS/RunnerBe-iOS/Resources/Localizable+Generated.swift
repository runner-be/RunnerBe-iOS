// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Ko-kr
  internal static let locale = L10n.tr("Localizable", "Locale")

  internal enum Additional {
    internal enum Gender {
      /// 만
      internal static let limit = L10n.tr("Localizable", "Additional.Gender.Limit")
    }
  }

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

  internal enum BookMark {
    internal enum Main {
      internal enum NavBar {
        /// 찜 목록
        internal static let title = L10n.tr("Localizable", "BookMark.Main.NavBar.title")
      }
    }
  }

  internal enum DateUtil {
    /// UTC
    internal static let timezone = L10n.tr("Localizable", "DateUtil.Timezone")
  }

  internal enum EmailCertification {
    /// 해당 정보는 러너님이 직장임을 확인하는 용도로만
    internal static let subTitle1 = L10n.tr("Localizable", "EmailCertification.subTitle1")
    /// 사용되며, 외부에 공개되지 않습니다.
    internal static let subTitle2 = L10n.tr("Localizable", "EmailCertification.subTitle2")
    /// 회사 이메일로
    internal static let title1 = L10n.tr("Localizable", "EmailCertification.title1")
    /// 직장을 인증해주세요
    internal static let title2 = L10n.tr("Localizable", "EmailCertification.title2")
    internal enum Button {
      internal enum Certificate {
        /// 인증하기
        internal static let firstSend = L10n.tr("Localizable", "EmailCertification.Button.Certificate.firstSend")
        /// 재전송
        internal static let resend = L10n.tr("Localizable", "EmailCertification.Button.Certificate.resend")
      }
      internal enum NotHaveEmail {
        /// 회사 이메일이 없어요
        internal static let title = L10n.tr("Localizable", "EmailCertification.Button.NotHaveEmail.title")
      }
    }
    internal enum Message {
      /// 인증 링크가 발송되었어요
      internal static let mailSend1 = L10n.tr("Localizable", "EmailCertification.Message.MailSend1")
      /// 메일이 오지 않는다면 스팸 메일함도 확인해주세요!
      internal static let mailSend2 = L10n.tr("Localizable", "EmailCertification.Message.MailSend2")
    }
    internal enum Modal {
      internal enum Button {
        /// OK
        internal static let yes = L10n.tr("Localizable", "EmailCertification.Modal.Button.yes")
      }
      internal enum Message {
        /// 메일 인증은 현재 접속하신
        internal static let _1 = L10n.tr("Localizable", "EmailCertification.Modal.Message.1")
        /// 기기 내에서만 가능합니다!
        internal static let _2 = L10n.tr("Localizable", "EmailCertification.Modal.Message.2")
      }
    }
    internal enum NavBar {
      /// TITLE
      internal static let title = L10n.tr("Localizable", "EmailCertification.NavBar.title")
    }
    internal enum EmailField {
      /// runnerbee@company.com
      internal static let placeholder = L10n.tr("Localizable", "EmailCertification.emailField.placeholder")
    }
    internal enum Error {
      /// 이미 사용 중인 이메일이에요!
      internal static let duplicated = L10n.tr("Localizable", "EmailCertification.error.duplicated")
    }
  }

  internal enum Gender {
    /// 여성
    internal static let female = L10n.tr("Localizable", "Gender.female")
    /// 남성
    internal static let male = L10n.tr("Localizable", "Gender.male")
    /// 전체
    internal static let `none` = L10n.tr("Localizable", "Gender.none")
  }

  internal enum Home {
    internal enum Filter {
      internal enum Age {
        /// 모든연령
        internal static let all = L10n.tr("Localizable", "Home.Filter.Age.all")
        /// 모집 연령
        internal static let title = L10n.tr("Localizable", "Home.Filter.Age.title")
      }
      internal enum Gender {
        /// 모집 성별
        internal static let title = L10n.tr("Localizable", "Home.Filter.Gender.title")
      }
      internal enum Job {
        /// 모집 직군
        internal static let title = L10n.tr("Localizable", "Home.Filter.Job.title")
      }
      internal enum NavBar {
        /// 필터
        internal static let title = L10n.tr("Localizable", "Home.Filter.NavBar.title")
      }
      internal enum Place {
        /// 모임장소
        internal static let title = L10n.tr("Localizable", "Home.Filter.Place.title")
      }
    }
    internal enum MessageList {
      internal enum NavBar {
        /// 삭제
        internal static let rightItem = L10n.tr("Localizable", "Home.MessageList.NavBar.RightItem")
        /// 쪽지
        internal static let title = L10n.tr("Localizable", "Home.MessageList.NavBar.Title")
      }
    }
    internal enum PostDetail {
      internal enum Guest {
        /// 신청완료
        internal static let applied = L10n.tr("Localizable", "Home.PostDetail.Guest.Applied")
        /// 신청하기
        internal static let apply = L10n.tr("Localizable", "Home.PostDetail.Guest.Apply")
      }
      internal enum Participant {
        /// 신청한 러너가 없어요!
        internal static let empty = L10n.tr("Localizable", "Home.PostDetail.Participant.empty")
        /// 신청한 러너
        internal static let title = L10n.tr("Localizable", "Home.PostDetail.Participant.title")
      }
      internal enum Writer {
        /// 마감된 게시글이에요
        internal static let finished = L10n.tr("Localizable", "Home.PostDetail.Writer.Finished")
        /// 마감하기
        internal static let finishing = L10n.tr("Localizable", "Home.PostDetail.Writer.Finishing")
        /// 거절하기
        internal static let no = L10n.tr("Localizable", "Home.PostDetail.Writer.No")
        /// 수락하기
        internal static let yes = L10n.tr("Localizable", "Home.PostDetail.Writer.Yes")
      }
    }
    internal enum PostList {
      internal enum Cell {
        internal enum Cover {
          /// 모집을 마감했어요
          internal static let closed = L10n.tr("Localizable", "Home.PostList.Cell.Cover.Closed")
        }
      }
      internal enum Filter {
        internal enum CheckBox {
          /// 마감 포함
          internal static let includeClosedPost = L10n.tr("Localizable", "Home.PostList.Filter.CheckBox.IncludeClosedPost")
        }
        internal enum Order {
          /// 거리순
          internal static let distance = L10n.tr("Localizable", "Home.PostList.Filter.Order.Distance")
          /// 최신순
          internal static let newest = L10n.tr("Localizable", "Home.PostList.Filter.Order.Newest")
          /// 찜순
          internal static let numBookMark = L10n.tr("Localizable", "Home.PostList.Filter.Order.NumBookMark")
        }
      }
      internal enum NavBar {
        /// 러너비
        internal static let title = L10n.tr("Localizable", "Home.PostList.NavBar.title")
      }
    }
  }

  internal enum Job {
    /// 재무/회계
    internal static let acc = L10n.tr("Localizable", "Job.ACC")
    /// CS
    internal static let cus = L10n.tr("Localizable", "Job.CUS")
    /// 디자인
    internal static let des = L10n.tr("Localizable", "Job.DES")
    /// 개발
    internal static let dev = L10n.tr("Localizable", "Job.DEV")
    /// 교육
    internal static let edu = L10n.tr("Localizable", "Job.EDU")
    /// 인사
    internal static let hur = L10n.tr("Localizable", "Job.HUR")
    /// 의료
    internal static let med = L10n.tr("Localizable", "Job.MED")
    /// 마케팅/PR
    internal static let mpr = L10n.tr("Localizable", "Job.MPR")
    /// 생산
    internal static let pro = L10n.tr("Localizable", "Job.PRO")
    /// 기획/전략/경영
    internal static let psm = L10n.tr("Localizable", "Job.PSM")
    /// 공무원
    internal static let psv = L10n.tr("Localizable", "Job.PSV")
    /// 연구
    internal static let res = L10n.tr("Localizable", "Job.RES")
    /// 영업/제휴
    internal static let saf = L10n.tr("Localizable", "Job.SAF")
    /// 서비스
    internal static let ser = L10n.tr("Localizable", "Job.SER")
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

  internal enum MyPage {
    internal enum EditInfo {
      internal enum Job {
        /// 나의 직군
        internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.Job.title")
      }
      internal enum NavBar {
        /// 내 정보 수정
        internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.NavBar.title")
      }
      internal enum NickName {
        /// 닉네임 변경
        internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.NickName.title")
        internal enum Button {
          /// 등록하기
          internal static let apply = L10n.tr("Localizable", "MyPage.EditInfo.NickName.Button.Apply")
          /// 변경불가
          internal static let cant = L10n.tr("Localizable", "MyPage.EditInfo.NickName.Button.Cant")
          internal enum NickNameChanged {
            /// 등록 완료
            internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.NickName.Button.NickNameChanged.title")
          }
        }
        internal enum ErrorLabel {
          /// 중복된 닉네임이에요!
          internal static let duplicated = L10n.tr("Localizable", "MyPage.EditInfo.NickName.ErrorLabel.duplicated")
          /// 영어 대문자, 특수문자, 띄어쓰기는 사용할 수 없습니다.
          internal static let form = L10n.tr("Localizable", "MyPage.EditInfo.NickName.ErrorLabel.form")
        }
        internal enum InfoLabel {
          /// 닉네임 변경이 완료되어 추가 변경은 불가능해요
          internal static let alreadychanged = L10n.tr("Localizable", "MyPage.EditInfo.NickName.InfoLabel.alreadychanged")
          /// 닉네임은 딱 한 번만 바꿀 수 있어요
          internal static let caution = L10n.tr("Localizable", "MyPage.EditInfo.NickName.InfoLabel.caution")
        }
        internal enum TextField {
          internal enum PlaceHolder {
            /// 김출근
            internal static let changed = L10n.tr("Localizable", "MyPage.EditInfo.NickName.TextField.PlaceHolder.changed")
            /// 8자 이내(영어 소문자/한글/숫자)
            internal static let rule = L10n.tr("Localizable", "MyPage.EditInfo.NickName.TextField.PlaceHolder.rule")
          }
        }
      }
    }
    internal enum Main {
      internal enum Cell {
        internal enum Button {
          internal enum Attend {
            /// 출석하기
            internal static let title = L10n.tr("Localizable", "MyPage.Main.Cell.Button.Attend.title")
          }
        }
        internal enum Cover {
          internal enum Attend {
            /// 불참했어요 😭
            internal static let no = L10n.tr("Localizable", "MyPage.Main.Cell.Cover.Attend.No")
            /// 출석을 완료했어요 😎
            internal static let yes = L10n.tr("Localizable", "MyPage.Main.Cell.Cover.Attend.Yes")
          }
        }
      }
    }
    internal enum Maker {
      internal enum NavBar {
        /// 만든 사람들
        internal static let title = L10n.tr("Localizable", "MyPage.Maker.NavBar.title")
      }
    }
    internal enum MyPost {
      internal enum Empty {
        /// 아직 러닝에 참여하지 않았어요!
        internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Empty.title")
        internal enum Button {
          /// 참여해볼까요? 👉
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Empty.Button.title")
        }
      }
    }
    internal enum MyRunning {
      internal enum Empty {
        /// 아직 모임을 만들지 않았어요!
        internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Empty.title")
        internal enum Button {
          /// 모임을 만들어볼까요? 👉
          internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Empty.Button.title")
        }
      }
    }
    internal enum Settings {
      internal enum Category {
        internal enum AboutRunnerbe {
          internal enum Instagram {
            /// 러너비 인스타그램
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.AboutRunnerbe.Instagram.title")
          }
          internal enum Maker {
            /// 만든 사람들
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.AboutRunnerbe.Maker.title")
          }
        }
        internal enum Account {
          internal enum Logout {
            /// 로그아웃
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Account.Logout.title")
          }
        }
        internal enum Policy {
          internal enum License {
            ///  오픈소스 라이센스
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Policy.License.title")
          }
          internal enum Privacy {
            /// 개인정보 처리방침
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Policy.Privacy.title")
          }
          internal enum Term {
            /// 이용 약관
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Policy.Term.title")
          }
          internal enum Version {
            /// 버전 정보
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Policy.Version.title")
          }
        }
      }
      internal enum Modal {
        internal enum Logout {
          /// 정말 로그아웃하시겠어요?
          internal static let content = L10n.tr("Localizable", "MyPage.Settings.Modal.Logout.Content")
          internal enum Button {
            /// 아니오
            internal static let cancel = L10n.tr("Localizable", "MyPage.Settings.Modal.Logout.Button.cancel")
            /// 네
            internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.Logout.Button.ok")
          }
        }
        internal enum NickName {
          /// 닉네임 변경은 1회만 가능하며 재변경은 불가능해요!
          /// 정말 변경하시겠어요?
          internal static let content = L10n.tr("Localizable", "MyPage.Settings.Modal.NickName.Content")
          internal enum Button {
            /// 더 고민할래요
            internal static let cancel = L10n.tr("Localizable", "MyPage.Settings.Modal.NickName.Button.cancel")
            /// 네
            internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.NickName.Button.ok")
          }
        }
      }
      internal enum NavBar {
        /// 설정
        internal static let title = L10n.tr("Localizable", "MyPage.Settings.NavBar.title")
      }
    }
    internal enum Tab {
      internal enum MyParticipant {
        /// 참여 러닝
        internal static let title = L10n.tr("Localizable", "MyPage.Tab.MyParticipant.title")
      }
      internal enum MyPost {
        /// 작성한 글
        internal static let title = L10n.tr("Localizable", "MyPage.Tab.MyPost.title")
      }
    }
  }

  internal enum NavBar {
    internal enum Right {
      internal enum First {
        /// 다음
        internal static let next = L10n.tr("Localizable", "NavBar.Right.First.next")
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

  internal enum Onboarding {
    internal enum Modal {
      internal enum Cancel {
        internal enum Button {
          /// 아니요
          internal static let no = L10n.tr("Localizable", "Onboarding.Modal.Cancel.Button.no")
          /// 네
          internal static let yes = L10n.tr("Localizable", "Onboarding.Modal.Cancel.Button.yes")
        }
        internal enum Message {
          /// 정보를 입력하지 않으면
          internal static let _1 = L10n.tr("Localizable", "Onboarding.Modal.Cancel.Message.1")
          /// 둘러보기만 가능해요! 그만할까요?
          internal static let _2 = L10n.tr("Localizable", "Onboarding.Modal.Cancel.Message.2")
        }
      }
    }
  }

  internal enum OnboardingCompletion {
    /// 이제 러너비에서 함께 달려볼까요?
    internal static let subTitle = L10n.tr("Localizable", "OnboardingCompletion.subTitle")
    /// 나를 충분히 소개했어요. 달릴 준비 완료!
    internal static let title = L10n.tr("Localizable", "OnboardingCompletion.title")
    internal enum Button {
      /// Start!
      internal static let start = L10n.tr("Localizable", "OnboardingCompletion.Button.start")
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

  internal enum PolicyDetail {
    internal enum NavBar {
      /// 제목
      internal static let title = L10n.tr("Localizable", "PolicyDetail.NavBar.title")
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

  internal enum Post {
    internal enum Date {
      /// 3/31 (금) AM 6:00
      internal static let placeHolder = L10n.tr("Localizable", "Post.Date.PlaceHolder")
      /// 일시
      internal static let title = L10n.tr("Localizable", "Post.Date.Title")
    }
    internal enum Detail {
      internal enum NavBar {
        /// 등록
        internal static let rightItem = L10n.tr("Localizable", "Post.Detail.NavBar.RightItem")
        /// 게시글 작성
        internal static let title = L10n.tr("Localizable", "Post.Detail.NavBar.title")
      }
      internal enum NumParticipant {
        /// 모임 인원은 최대 8명 까지 입니다.
        internal static let maxError = L10n.tr("Localizable", "Post.Detail.NumParticipant.maxError")
        /// 모임 인원은 최소 2명 부터 가능해요!
        internal static let mixError = L10n.tr("Localizable", "Post.Detail.NumParticipant.mixError")
        /// 인원
        internal static let title = L10n.tr("Localizable", "Post.Detail.NumParticipant.title")
      }
      internal enum TextContent {
        /// 함께할 러너들에게 하실 말씀이 있나요?
        internal static let placeHolder = L10n.tr("Localizable", "Post.Detail.TextContent.PlaceHolder")
        /// 하고 싶은 말(선택)
        internal static let title = L10n.tr("Localizable", "Post.Detail.TextContent.title")
      }
    }
    internal enum Modal {
      internal enum Time {
        /// 분
        internal static let minute = L10n.tr("Localizable", "Post.Modal.Time.minute")
        /// 시간
        internal static let time = L10n.tr("Localizable", "Post.Modal.Time.time")
      }
    }
    internal enum Place {
      /// 모임 장소
      internal static let title = L10n.tr("Localizable", "Post.Place.Title")
      internal enum Guide {
        /// * 정확한 위치는 참여 러너에게만 보여요!
        internal static let readable = L10n.tr("Localizable", "Post.Place.Guide.Readable")
      }
    }
    internal enum Time {
      /// 모임은 최대 5시간까지 가능해요
      internal static let error = L10n.tr("Localizable", "Post.Time.Error")
      /// 0시간 20분
      internal static let placeHolder = L10n.tr("Localizable", "Post.Time.PlaceHolder")
      /// 소요 시간
      internal static let title = L10n.tr("Localizable", "Post.Time.Title")
    }
    internal enum Title {
      /// ex) A 직군 모여라, 묵언 러닝 하실 분, 마라톤 완주!
      internal static let placeHolder = L10n.tr("Localizable", "Post.Title.PlaceHolder")
      /// 제목
      internal static let title = L10n.tr("Localizable", "Post.Title.Title")
    }
    internal enum WorkTime {
      /// 퇴근 후
      internal static let afterWork = L10n.tr("Localizable", "Post.WorkTime.AfterWork")
      /// 출근 전
      internal static let beforeWork = L10n.tr("Localizable", "Post.WorkTime.BeforeWork")
      /// 휴일
      internal static let dayOff = L10n.tr("Localizable", "Post.WorkTime.DayOff")
    }
    internal enum Write {
      internal enum NavBar {
        /// 게시글 작성
        internal static let title = L10n.tr("Localizable", "Post.Write.NavBar.title")
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
    internal enum NavBar {
      /// TITLE
      internal static let title = L10n.tr("Localizable", "SelectJobGroup.NavBar.title")
    }
  }

  internal enum WaitCertification {
    /// 제출이 완료되었습니다. 확인 후 알려드릴게요!
    internal static let title1 = L10n.tr("Localizable", "WaitCertification.title1")
    internal enum Button {
      /// 메인 화면으로
      internal static let toMain = L10n.tr("Localizable", "WaitCertification.Button.toMain")
    }
    internal enum SubTitle1 {
      /// 소요 시간은 
      internal static let _1 = L10n.tr("Localizable", "WaitCertification.subTitle1.1")
      /// 최대 6시간
      internal static let _2 = L10n.tr("Localizable", "WaitCertification.subTitle1.2")
      ///  정도이며, 완료 시 알림을 보내드립니다. 그 전까지는 둘러보기만 가능해요
      internal static let _3 = L10n.tr("Localizable", "WaitCertification.subTitle1.3")
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
