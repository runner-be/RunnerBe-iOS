// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// "Key" = "localizing한 문자열"
  ///  ex) "Hello" = "Hello"; << 세미콜론(;) 필수
  ///  MARK: 세미콜론 붙이지 않으면 빌드 오류가 발생하므로 유의해주세요!
  internal static let locale = L10n.tr("Localizable", "Locale", fallback: "Ko-kr")
  internal enum Additional {
    internal enum Gender {
      /// 만
      internal static let limit = L10n.tr("Localizable", "Additional.Gender.Limit", fallback: "만")
    }
  }
  internal enum BookMark {
    internal enum Main {
      internal enum Empty {
        internal enum After {
          /// 찜한 퇴근 후 모임이 없어요!
          internal static let title = L10n.tr("Localizable", "BookMark.Main.Empty.after.title", fallback: "찜한 퇴근 후 모임이 없어요!")
        }
        internal enum All {
          /// 찜한 모임이 없어요!
          internal static let title = L10n.tr("Localizable", "BookMark.Main.Empty.all.title", fallback: "찜한 모임이 없어요!")
        }
        internal enum Before {
          /// 찜한 출근 전 모임이 없어요!
          internal static let title = L10n.tr("Localizable", "BookMark.Main.Empty.before.title", fallback: "찜한 출근 전 모임이 없어요!")
        }
        internal enum Holiday {
          /// 찜한 휴일 모임이 없어요!
          internal static let title = L10n.tr("Localizable", "BookMark.Main.Empty.holiday.title", fallback: "찜한 휴일 모임이 없어요!")
        }
      }
      internal enum NavBar {
        /// 찜 목록
        internal static let title = L10n.tr("Localizable", "BookMark.Main.NavBar.title", fallback: "찜 목록")
      }
    }
  }
  internal enum DateUtil {
    /// UTC
    internal static let timezone = L10n.tr("Localizable", "DateUtil.Timezone", fallback: "UTC")
  }
  internal enum Gender {
    /// 여성
    internal static let female = L10n.tr("Localizable", "Gender.female", fallback: "여성")
    /// 남성
    internal static let male = L10n.tr("Localizable", "Gender.male", fallback: "남성")
    /// 전체
    internal static let `none` = L10n.tr("Localizable", "Gender.none", fallback: "전체")
  }
  internal enum Home {
    internal enum BottomSheet {
      /// 러닝 목록
      internal static let title = L10n.tr("Localizable", "Home.BottomSheet.title", fallback: "러닝 목록")
    }
    internal enum Filter {
      internal enum Afterparty {
        /// 뒤풀이
        internal static let title = L10n.tr("Localizable", "Home.Filter.Afterparty.title", fallback: "뒤풀이")
      }
      internal enum Age {
        /// 모든연령
        internal static let all = L10n.tr("Localizable", "Home.Filter.Age.all", fallback: "모든연령")
        /// 연령
        internal static let title = L10n.tr("Localizable", "Home.Filter.Age.title", fallback: "연령")
      }
      internal enum Gender {
        /// 모집 성별
        internal static let title = L10n.tr("Localizable", "Home.Filter.Gender.title", fallback: "모집 성별")
      }
      internal enum Job {
        /// 모집 직군
        internal static let title = L10n.tr("Localizable", "Home.Filter.Job.title", fallback: "모집 직군")
      }
      internal enum NavBar {
        /// 필터
        internal static let title = L10n.tr("Localizable", "Home.Filter.NavBar.title", fallback: "필터")
      }
      internal enum Place {
        /// 모임장소
        internal static let title = L10n.tr("Localizable", "Home.Filter.Place.title", fallback: "모임장소")
      }
      internal enum RunningPace {
        /// 페이스 난이도
        internal static let title = L10n.tr("Localizable", "Home.Filter.RunningPace.title", fallback: "페이스 난이도")
      }
    }
    internal enum Map {
      internal enum RefreshButton {
        /// 이 지역 재검색
        internal static let title = L10n.tr("Localizable", "Home.Map.RefreshButton.title", fallback: "이 지역 재검색")
      }
    }
    internal enum PostDetail {
      internal enum Guest {
        /// 신청완료
        internal static let applied = L10n.tr("Localizable", "Home.PostDetail.Guest.Applied", fallback: "신청완료")
        /// 신청하기
        internal static let apply = L10n.tr("Localizable", "Home.PostDetail.Guest.Apply", fallback: "신청하기")
        /// 조건에 맞지 않는 모집글이에요
        internal static let notSatisfied = L10n.tr("Localizable", "Home.PostDetail.Guest.NotSatisfied", fallback: "조건에 맞지 않는 모집글이에요")
      }
      internal enum Participant {
        /// 신청한 러너가 없어요!
        internal static let empty = L10n.tr("Localizable", "Home.PostDetail.Participant.empty", fallback: "신청한 러너가 없어요!")
        /// 신청한 러너
        internal static let title = L10n.tr("Localizable", "Home.PostDetail.Participant.title", fallback: "신청한 러너")
      }
      internal enum Report {
        /// 부적절한 신고는 수락되지 않으며,
        /// 활동 제재의 원인이 될 수 있습니다.
        /// 정말 신고하시겠어요?
        internal static let content = L10n.tr("Localizable", "Home.PostDetail.Report.content", fallback: "부적절한 신고는 수락되지 않으며,\n활동 제재의 원인이 될 수 있습니다.\n정말 신고하시겠어요?")
        internal enum Button {
          /// 아니오
          internal static let no = L10n.tr("Localizable", "Home.PostDetail.Report.Button.no", fallback: "아니오")
          /// 예
          internal static let ok = L10n.tr("Localizable", "Home.PostDetail.Report.Button.ok", fallback: "예")
        }
      }
      internal enum Writer {
        /// 마감된 게시글이에요
        internal static let finished = L10n.tr("Localizable", "Home.PostDetail.Writer.Finished", fallback: "마감된 게시글이에요")
        /// 마감하기
        internal static let finishing = L10n.tr("Localizable", "Home.PostDetail.Writer.Finishing", fallback: "마감하기")
        /// 거절하기
        internal static let no = L10n.tr("Localizable", "Home.PostDetail.Writer.No", fallback: "거절하기")
        /// 수락하기
        internal static let yes = L10n.tr("Localizable", "Home.PostDetail.Writer.Yes", fallback: "수락하기")
      }
    }
    internal enum PostList {
      internal enum Cell {
        internal enum Cover {
          /// 모집을 마감했어요
          internal static let closed = L10n.tr("Localizable", "Home.PostList.Cell.Cover.Closed", fallback: "모집을 마감했어요")
        }
      }
      internal enum Empty {
        /// 아직 진행중인 모임이 없어요
        internal static let title = L10n.tr("Localizable", "Home.PostList.Empty.title", fallback: "아직 진행중인 모임이 없어요")
      }
      internal enum Filter {
        internal enum CheckBox {
          /// 마감 포함
          internal static let includeClosedPost = L10n.tr("Localizable", "Home.PostList.Filter.CheckBox.IncludeClosedPost", fallback: "마감 포함")
        }
        internal enum Order {
          /// 거리순
          internal static let distance = L10n.tr("Localizable", "Home.PostList.Filter.Order.Distance", fallback: "거리순")
          /// 최신순
          internal static let newest = L10n.tr("Localizable", "Home.PostList.Filter.Order.Newest", fallback: "최신순")
          /// 찜순
          internal static let numBookMark = L10n.tr("Localizable", "Home.PostList.Filter.Order.NumBookMark", fallback: "찜순")
        }
      }
      internal enum NavBar {
        /// 러너비
        internal static let title = L10n.tr("Localizable", "Home.PostList.NavBar.title", fallback: "러너비")
      }
    }
  }
  internal enum Job {
    /// 재무/회계
    internal static let acc = L10n.tr("Localizable", "Job.ACC", fallback: "재무/회계")
    /// CS
    internal static let cus = L10n.tr("Localizable", "Job.CUS", fallback: "CS")
    /// 디자인
    internal static let des = L10n.tr("Localizable", "Job.DES", fallback: "디자인")
    /// 개발
    internal static let dev = L10n.tr("Localizable", "Job.DEV", fallback: "개발")
    /// 교육
    internal static let edu = L10n.tr("Localizable", "Job.EDU", fallback: "교육")
    /// 인사
    internal static let hur = L10n.tr("Localizable", "Job.HUR", fallback: "인사")
    /// 의료
    internal static let med = L10n.tr("Localizable", "Job.MED", fallback: "의료")
    /// 마케팅/PR
    internal static let mpr = L10n.tr("Localizable", "Job.MPR", fallback: "마케팅/PR")
    /// 생산
    internal static let pro = L10n.tr("Localizable", "Job.PRO", fallback: "생산")
    /// 기획/전략/경영
    internal static let psm = L10n.tr("Localizable", "Job.PSM", fallback: "기획/전략/경영")
    /// 공무원
    internal static let psv = L10n.tr("Localizable", "Job.PSV", fallback: "공무원")
    /// 연구
    internal static let res = L10n.tr("Localizable", "Job.RES", fallback: "연구")
    /// 영업/제휴
    internal static let saf = L10n.tr("Localizable", "Job.SAF", fallback: "영업/제휴")
    /// 서비스
    internal static let ser = L10n.tr("Localizable", "Job.SER", fallback: "서비스")
  }
  internal enum LoggedOut {
    internal enum AppleBtn {
      /// Login with Apple
      internal static let text = L10n.tr("Localizable", "LoggedOut.AppleBtn.text", fallback: "Login with Apple")
    }
    internal enum KakaoBtn {
      /// Login with Kakao
      internal static let text = L10n.tr("Localizable", "LoggedOut.KakaoBtn.text", fallback: "Login with Kakao")
    }
    internal enum NaverBtn {
      /// Login with Naver
      internal static let text = L10n.tr("Localizable", "LoggedOut.NaverBtn.text", fallback: "Login with Naver")
    }
  }
  internal enum MainTabbar {
    internal enum Item {
      internal enum BookMark {
        /// BookMark
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.BookMark.title", fallback: "BookMark")
      }
      internal enum Home {
        /// Home
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.Home.title", fallback: "Home")
      }
      internal enum Message {
        /// Message
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.Message.title", fallback: "Message")
      }
      internal enum MyPage {
        /// MyPage
        internal static let title = L10n.tr("Localizable", "MainTabbar.Item.MyPage.title", fallback: "MyPage")
      }
    }
  }
  internal enum MessageList {
    internal enum Chat {
      /// 내용을 입력하세요
      internal static let placeHolder = L10n.tr("Localizable", "MessageList.Chat.PlaceHolder", fallback: "내용을 입력하세요")
      internal enum NavBar {
        /// 신고하기
        internal static let title = L10n.tr("Localizable", "MessageList.Chat.NavBar.Title", fallback: "신고하기")
      }
    }
    internal enum NavBar {
      /// 신고
      internal static let rightItem = L10n.tr("Localizable", "MessageList.NavBar.RightItem", fallback: "신고")
      /// 러닝톡
      internal static let title = L10n.tr("Localizable", "MessageList.NavBar.Title", fallback: "러닝톡")
    }
  }
  internal enum Modal {
    internal enum SelectDate {
      internal enum Button {
        /// OK
        internal static let ok = L10n.tr("Localizable", "Modal.SelectDate.Button.ok", fallback: "OK")
      }
    }
    internal enum SelectTime {
      internal enum Button {
        /// OK
        internal static let ok = L10n.tr("Localizable", "Modal.SelectTime.Button.ok", fallback: "OK")
      }
    }
    internal enum TakePhoto {
      internal enum Button {
        /// 앨범에서 가져오기
        internal static let album = L10n.tr("Localizable", "Modal.TakePhoto.Button.album", fallback: "앨범에서 가져오기")
        /// 기본 이미지로 변경하기
        internal static let `default` = L10n.tr("Localizable", "Modal.TakePhoto.Button.default", fallback: "기본 이미지로 변경하기")
        /// 촬영하기
        internal static let photo = L10n.tr("Localizable", "Modal.TakePhoto.Button.photo", fallback: "촬영하기")
      }
    }
  }
  internal enum MyPage {
    internal enum EditInfo {
      internal enum Job {
        /// 나의 직군
        internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.Job.title", fallback: "나의 직군")
        internal enum ErrorLabel {
          /// * 직군은 3개월에 한 번 변경할 수 있어요!
          internal static let cannotIn3Month = L10n.tr("Localizable", "MyPage.EditInfo.Job.ErrorLabel.cannotIn3Month", fallback: "* 직군은 3개월에 한 번 변경할 수 있어요!")
        }
      }
      internal enum NavBar {
        /// 내 정보 수정
        internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.NavBar.title", fallback: "내 정보 수정")
      }
      internal enum NickName {
        /// 닉네임
        internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.NickName.title", fallback: "닉네임")
        internal enum Button {
          /// 등록하기
          internal static let apply = L10n.tr("Localizable", "MyPage.EditInfo.NickName.Button.Apply", fallback: "등록하기")
          /// 변경불가
          internal static let cant = L10n.tr("Localizable", "MyPage.EditInfo.NickName.Button.Cant", fallback: "변경불가")
          internal enum NickNameChanged {
            /// 등록 완료
            internal static let title = L10n.tr("Localizable", "MyPage.EditInfo.NickName.Button.NickNameChanged.title", fallback: "등록 완료")
          }
        }
        internal enum ErrorLabel {
          /// 중복된 닉네임이에요!
          internal static let duplicated = L10n.tr("Localizable", "MyPage.EditInfo.NickName.ErrorLabel.duplicated", fallback: "중복된 닉네임이에요!")
          /// 영어 대문자, 특수문자, 띄어쓰기는 쓸 수 없어요!
          internal static let form = L10n.tr("Localizable", "MyPage.EditInfo.NickName.ErrorLabel.form", fallback: "영어 대문자, 특수문자, 띄어쓰기는 쓸 수 없어요!")
        }
        internal enum InfoLabel {
          /// * 닉네임 변경이 완료되어 추가 변경은 불가능해요!
          internal static let alreadychanged = L10n.tr("Localizable", "MyPage.EditInfo.NickName.InfoLabel.alreadychanged", fallback: "* 닉네임 변경이 완료되어 추가 변경은 불가능해요!")
          /// * 딱 한 번만 바꿀 수 있어요!
          internal static let caution = L10n.tr("Localizable", "MyPage.EditInfo.NickName.InfoLabel.caution", fallback: "* 딱 한 번만 바꿀 수 있어요!")
        }
        internal enum TextField {
          internal enum PlaceHolder {
            /// 김출근
            internal static let changed = L10n.tr("Localizable", "MyPage.EditInfo.NickName.TextField.PlaceHolder.changed", fallback: "김출근")
            /// 8자 이내(영어 소문자/한글/숫자)
            internal static let rule = L10n.tr("Localizable", "MyPage.EditInfo.NickName.TextField.PlaceHolder.rule", fallback: "8자 이내(영어 소문자/한글/숫자)")
          }
        }
      }
    }
    internal enum Main {
      internal enum Cell {
        internal enum Button {
          internal enum Attend {
            /// 출석하기
            internal static let title = L10n.tr("Localizable", "MyPage.Main.Cell.Button.Attend.title", fallback: "출석하기")
          }
        }
        internal enum Cover {
          internal enum Attend {
            /// 불참했어요 😭
            internal static let no = L10n.tr("Localizable", "MyPage.Main.Cell.Cover.Attend.No", fallback: "불참했어요 😭")
            /// 출석을 완료했어요 😎
            internal static let yes = L10n.tr("Localizable", "MyPage.Main.Cell.Cover.Attend.Yes", fallback: "출석을 완료했어요 😎")
          }
        }
      }
    }
    internal enum Maker {
      internal enum NavBar {
        /// 만든 사람들
        internal static let title = L10n.tr("Localizable", "MyPage.Maker.NavBar.title", fallback: "만든 사람들")
      }
    }
    internal enum ManageAttendance {
      internal enum Absence {
        /// 불참했어요 😭
        internal static let title = L10n.tr("Localizable", "MyPage.ManageAttendance.Absence.title", fallback: "불참했어요 😭")
      }
      internal enum Attendance {
        /// 출석을 완료했어요 😎
        internal static let title = L10n.tr("Localizable", "MyPage.ManageAttendance.Attendance.title", fallback: "출석을 완료했어요 😎")
      }
      internal enum Before {
        /// 출석을 체크하지 않았어요 😣
        internal static let title = L10n.tr("Localizable", "MyPage.ManageAttendance.Before.title", fallback: "출석을 체크하지 않았어요 😣")
      }
    }
    internal enum MyPost {
      internal enum Empty {
        /// 아직 모임을 만들지 않았어요!
        internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Empty.title", fallback: "아직 모임을 만들지 않았어요!")
        internal enum Button {
          /// 모임을 만들어볼까요? 👉
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Empty.Button.title", fallback: "모임을 만들어볼까요? 👉")
        }
      }
      internal enum Manage {
        internal enum Absent {
          /// 결석
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Manage.Absent.title", fallback: "결석")
        }
        internal enum After {
          /// 출석 관리하기
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Manage.After.title", fallback: "출석 관리하기")
        }
        internal enum Attend {
          /// 출석
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Manage.Attend.title", fallback: "출석")
        }
        internal enum Before {
          /// 러닝 후에 출석을 관리해주세요
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Manage.Before.title", fallback: "러닝 후에 출석을 관리해주세요")
        }
        internal enum Finished {
          /// 출석 확인하기
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Manage.Finished.title", fallback: "출석 확인하기")
        }
        internal enum Modal {
          /// 출석 관리 시간이 만료되었어요!
          internal static let content = L10n.tr("Localizable", "MyPage.MyPost.Manage.Modal.content", fallback: "출석 관리 시간이 만료되었어요!")
          internal enum Button {
            /// 마이페이지로 이동
            internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Manage.Modal.button.title", fallback: "마이페이지로 이동")
          }
        }
        internal enum SaveButton {
          /// 제출하기
          internal static let title = L10n.tr("Localizable", "MyPage.MyPost.Manage.SaveButton.title", fallback: "제출하기")
        }
        internal enum TimeGuide {
          internal enum Content {
            /// 함께한 러너들의 출석을 
            internal static let first = L10n.tr("Localizable", "MyPage.MyPost.Manage.TimeGuide.content.first", fallback: "함께한 러너들의 출석을 ")
            ///  후까지 체크할 수 있어요!
            internal static let second = L10n.tr("Localizable", "MyPage.MyPost.Manage.TimeGuide.content.second", fallback: " 후까지 체크할 수 있어요!")
          }
        }
      }
    }
    internal enum MyRunning {
      internal enum Attendance {
        internal enum Absence {
          /// 불참했어요 😭
          internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Attendance.Absence.title", fallback: "불참했어요 😭")
        }
        internal enum Attendance {
          /// 출석을 완료했어요 😎
          internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Attendance.Attendance.title", fallback: "출석을 완료했어요 😎")
        }
        internal enum Participate {
          internal enum Before {
            /// 리더의 체크를 기다리고 있어요
            internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Attendance.Participate.Before.title", fallback: "리더의 체크를 기다리고 있어요")
          }
          internal enum NotCheck {
            /// 리더가 출석을 체크하지 않았어요😂
            internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Attendance.Participate.NotCheck.title", fallback: "리더가 출석을 체크하지 않았어요😂")
          }
        }
        internal enum Writer {
          internal enum Before {
            /// 참여자의 출석을 체크해주세요
            internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Attendance.Writer.Before.title", fallback: "참여자의 출석을 체크해주세요")
          }
          internal enum NotCheck {
            /// 출석을 체크하지 않았어요😂
            internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Attendance.Writer.NotCheck.title", fallback: "출석을 체크하지 않았어요😂")
          }
        }
      }
      internal enum Empty {
        /// 아직 러닝에 참여하지 않았어요!
        internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Empty.title", fallback: "아직 러닝에 참여하지 않았어요!")
        internal enum Button {
          /// 참여해볼까요? 👉
          internal static let title = L10n.tr("Localizable", "MyPage.MyRunning.Empty.Button.title", fallback: "참여해볼까요? 👉")
        }
      }
    }
    internal enum Settings {
      internal enum Category {
        internal enum AboutRunnerbe {
          internal enum Instagram {
            /// 러너비 인스타그램
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.AboutRunnerbe.Instagram.title", fallback: "러너비 인스타그램")
          }
          internal enum Maker {
            /// 만든 사람들
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.AboutRunnerbe.Maker.title", fallback: "만든 사람들")
          }
        }
        internal enum Account {
          internal enum EditPassword {
            /// 비밀번호 변경
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Account.EditPassword.title", fallback: "비밀번호 변경")
          }
          internal enum Logout {
            /// 로그아웃
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Account.Logout.title", fallback: "로그아웃")
          }
          internal enum SignOut {
            /// 회원탈퇴
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Account.SignOut.title", fallback: "회원탈퇴")
          }
        }
        internal enum Policy {
          internal enum Privacy {
            /// 개인정보 처리방침
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Policy.Privacy.title", fallback: "개인정보 처리방침")
          }
          internal enum Term {
            /// 이용약관
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Policy.Term.title", fallback: "이용약관")
          }
          internal enum Version {
            /// 버전 정보
            internal static let title = L10n.tr("Localizable", "MyPage.Settings.Category.Policy.Version.title", fallback: "버전 정보")
          }
        }
      }
      internal enum Modal {
        internal enum Job {
          /// 직군 변경은 3개월에 1회 가능해요.
          /// 변경하시겠어요?
          internal static let content = L10n.tr("Localizable", "MyPage.Settings.Modal.Job.Content", fallback: "직군 변경은 3개월에 1회 가능해요.\n변경하시겠어요?")
          /// 아니오
          internal static let no = L10n.tr("Localizable", "MyPage.Settings.Modal.Job.no", fallback: "아니오")
          /// 네
          internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.Job.ok", fallback: "네")
        }
        internal enum Logout {
          /// 로그아웃 하시겠어요?
          internal static let content = L10n.tr("Localizable", "MyPage.Settings.Modal.Logout.Content", fallback: "로그아웃 하시겠어요?")
          internal enum Button {
            /// 아니오
            internal static let cancel = L10n.tr("Localizable", "MyPage.Settings.Modal.Logout.Button.cancel", fallback: "아니오")
            /// 네
            internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.Logout.Button.ok", fallback: "네")
          }
        }
        internal enum Manage {
          /// 출석 관리 시간이 만료되었어요!
          internal static let content = L10n.tr("Localizable", "MyPage.Settings.Modal.Manage.Content", fallback: "출석 관리 시간이 만료되었어요!")
          /// 마이페이지로 이동
          internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.Manage.ok", fallback: "마이페이지로 이동")
        }
        internal enum NickName {
          /// 닉네임 변경은 1회만 가능하며
          /// 재변경은 불가능해요!
          /// 정말 변경하시겠어요?
          internal static let content = L10n.tr("Localizable", "MyPage.Settings.Modal.NickName.Content", fallback: "닉네임 변경은 1회만 가능하며\n재변경은 불가능해요!\n정말 변경하시겠어요?")
          internal enum Button {
            /// 더 고민할래요
            internal static let cancel = L10n.tr("Localizable", "MyPage.Settings.Modal.NickName.Button.cancel", fallback: "더 고민할래요")
            /// 네
            internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.NickName.Button.ok", fallback: "네")
          }
        }
        internal enum Signout {
          /// 탈퇴하면 모든 러너 정보가 삭제돼요.
          /// 정말 탈퇴하시겠어요?
          internal static let message = L10n.tr("Localizable", "MyPage.Settings.Modal.Signout.message", fallback: "탈퇴하면 모든 러너 정보가 삭제돼요.\n정말 탈퇴하시겠어요?")
          /// 아니오
          internal static let no = L10n.tr("Localizable", "MyPage.Settings.Modal.Signout.no", fallback: "아니오")
          /// 예
          internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.Signout.ok", fallback: "예")
        }
        internal enum SignoutCompletion {
          /// 회원탈퇴가 완료되었습니다.
          /// 로그인페이지로 이동합니다.
          internal static let message = L10n.tr("Localizable", "MyPage.Settings.Modal.SignoutCompletion.message", fallback: "회원탈퇴가 완료되었습니다.\n로그인페이지로 이동합니다.")
          /// 이동
          internal static let ok = L10n.tr("Localizable", "MyPage.Settings.Modal.SignoutCompletion.ok", fallback: "이동")
        }
      }
      internal enum NavBar {
        /// 설정
        internal static let title = L10n.tr("Localizable", "MyPage.Settings.NavBar.title", fallback: "설정")
      }
      internal enum Push {
        /// 푸시 알림
        internal static let title = L10n.tr("Localizable", "MyPage.Settings.Push.title", fallback: "푸시 알림")
      }
    }
    internal enum Tab {
      internal enum MyParticipant {
        /// 참여 러닝
        internal static let title = L10n.tr("Localizable", "MyPage.Tab.MyParticipant.title", fallback: "참여 러닝")
      }
      internal enum MyPost {
        /// 작성한 글
        internal static let title = L10n.tr("Localizable", "MyPage.Tab.MyPost.title", fallback: "작성한 글")
      }
    }
  }
  internal enum NavBar {
    internal enum Right {
      internal enum First {
        /// 다음
        internal static let next = L10n.tr("Localizable", "NavBar.Right.First.next", fallback: "다음")
      }
    }
  }
  internal enum NickName {
    /// 한 번 정한 닉네임은 수정할 수 없어요.
    internal static let subtitle = L10n.tr("Localizable", "NickName.subtitle", fallback: "한 번 정한 닉네임은 수정할 수 없어요.")
    /// 어떤 닉네임으로
    internal static let title1 = L10n.tr("Localizable", "NickName.title1", fallback: "어떤 닉네임으로")
    /// 활동하실 건가요?
    internal static let title2 = L10n.tr("Localizable", "NickName.title2", fallback: "활동하실 건가요?")
    internal enum Button {
      internal enum CheckDup {
        /// 중복 확인
        internal static let title = L10n.tr("Localizable", "NickName.button.checkDup.title", fallback: "중복 확인")
      }
      internal enum SetNickname {
        /// 정했어요!
        internal static let title = L10n.tr("Localizable", "NickName.button.setNickname.title", fallback: "정했어요!")
      }
    }
    internal enum Error {
      /// 중복된 닉네임이에요!
      internal static let duplicated = L10n.tr("Localizable", "NickName.error.duplicated", fallback: "중복된 닉네임이에요!")
      /// 특수문자, 띄어쓰기는 쓸 수 없어요!
      internal static let textformat = L10n.tr("Localizable", "NickName.error.textformat", fallback: "특수문자, 띄어쓰기는 쓸 수 없어요!")
    }
    internal enum Textfield {
      /// 영어 8자/한글 6자까지 쓸 수 있어요.
      internal static let placeholder = L10n.tr("Localizable", "NickName.textfield.placeholder", fallback: "영어 8자/한글 6자까지 쓸 수 있어요.")
    }
  }
  internal enum Onboard {
    internal enum Cover {
      /// 나를 더 알려주면
      /// 모임에 참여할 수 있어요!
      internal static let title = L10n.tr("Localizable", "Onboard.Cover.Title", fallback: "나를 더 알려주면\n모임에 참여할 수 있어요!")
      internal enum Button {
        internal enum LookAround {
          /// 지금은 둘러보기만 할게요
          internal static let title = L10n.tr("Localizable", "Onboard.Cover.Button.LookAround.title", fallback: "지금은 둘러보기만 할게요")
        }
        internal enum Onboard {
          /// 나에 대해 알려주기
          internal static let title = L10n.tr("Localizable", "Onboard.Cover.Button.Onboard.title", fallback: "나에 대해 알려주기")
        }
      }
    }
    internal enum Wait {
      /// 내 소개를 확인 중이에요.
      /// 조금만 기다려주세요!
      internal static let title = L10n.tr("Localizable", "Onboard.Wait.Title", fallback: "내 소개를 확인 중이에요.\n조금만 기다려주세요!")
      internal enum Button {
        /// 메인 화면으로
        internal static let title = L10n.tr("Localizable", "Onboard.Wait.Button.title", fallback: "메인 화면으로")
      }
    }
  }
  internal enum Onboarding {
    internal enum Birth {
      /// 정확한 나이는 공개되지 않아요!
      internal static let subTitle1 = L10n.tr("Localizable", "Onboarding.Birth.subTitle1", fallback: "정확한 나이는 공개되지 않아요!")
      /// 20대 초반, 30대 중반 등으로 표기될 거에요.
      internal static let subTitle2 = L10n.tr("Localizable", "Onboarding.Birth.subTitle2", fallback: "20대 초반, 30대 중반 등으로 표기될 거에요.")
      /// 출생년도를 입력해주세요.
      internal static let title = L10n.tr("Localizable", "Onboarding.Birth.title", fallback: "출생년도를 입력해주세요.")
      internal enum NavBar {
        /// TITLE
        internal static let title = L10n.tr("Localizable", "Onboarding.Birth.NavBar.title", fallback: "TITLE")
      }
      internal enum Button {
        /// 다음
        internal static let next = L10n.tr("Localizable", "Onboarding.Birth.button.next", fallback: "다음")
      }
      internal enum Error {
        /// 19세 미만은 이용할 수 없어요!
        internal static let age = L10n.tr("Localizable", "Onboarding.Birth.error.age", fallback: "19세 미만은 이용할 수 없어요!")
      }
    }
    internal enum Completion {
      /// 이제 러너비에서 함께 달려볼까요?
      internal static let subTitle = L10n.tr("Localizable", "Onboarding.Completion.subTitle", fallback: "이제 러너비에서 함께 달려볼까요?")
      /// 나를 충분히 소개했어요. 달릴 준비 완료!
      internal static let title = L10n.tr("Localizable", "Onboarding.Completion.title", fallback: "나를 충분히 소개했어요. 달릴 준비 완료!")
      internal enum Button {
        /// START!
        internal static let start = L10n.tr("Localizable", "Onboarding.Completion.Button.start", fallback: "START!")
      }
    }
    internal enum Gender {
      /// 성별을 선택해주세요.
      internal static let title = L10n.tr("Localizable", "Onboarding.Gender.title", fallback: "성별을 선택해주세요.")
      internal enum Button {
        /// 다음
        internal static let next = L10n.tr("Localizable", "Onboarding.Gender.Button.next", fallback: "다음")
      }
      internal enum NavBar {
        /// TITLE
        internal static let title = L10n.tr("Localizable", "Onboarding.Gender.NavBar.title", fallback: "TITLE")
      }
    }
    internal enum Job {
      /// 추후 마이페이지에서 수정할 수 있어요!
      internal static let subTitle = L10n.tr("Localizable", "Onboarding.Job.subTitle", fallback: "추후 마이페이지에서 수정할 수 있어요!")
      /// 어떤 직군에서 활동하시나요?
      internal static let title = L10n.tr("Localizable", "Onboarding.Job.title", fallback: "어떤 직군에서 활동하시나요?")
      internal enum Button {
        internal enum Next {
          /// 완료
          internal static let title = L10n.tr("Localizable", "Onboarding.Job.Button.Next.title", fallback: "완료")
        }
      }
      internal enum NavBar {
        /// TITLE
        internal static let title = L10n.tr("Localizable", "Onboarding.Job.NavBar.title", fallback: "TITLE")
      }
    }
    internal enum Modal {
      internal enum Cancel {
        /// 정보를 입력하지 않으면
        /// 둘러보기만 가능해요! 그만할까요?
        internal static let message = L10n.tr("Localizable", "Onboarding.Modal.Cancel.Message", fallback: "정보를 입력하지 않으면\n둘러보기만 가능해요! 그만할까요?")
        internal enum Button {
          /// 아니요
          internal static let no = L10n.tr("Localizable", "Onboarding.Modal.Cancel.Button.no", fallback: "아니요")
          /// 네
          internal static let yes = L10n.tr("Localizable", "Onboarding.Modal.Cancel.Button.yes", fallback: "네")
        }
      }
    }
    internal enum PolicyDetail {
      internal enum NavBar {
        /// 제목
        internal static let title = L10n.tr("Localizable", "Onboarding.PolicyDetail.NavBar.title", fallback: "제목")
      }
    }
    internal enum PolicyTerm {
      /// 먼저 이용약관을 읽고 동의해주세요!
      internal static let title = L10n.tr("Localizable", "Onboarding.PolicyTerm.title", fallback: "먼저 이용약관을 읽고 동의해주세요!")
      internal enum Agree {
        internal enum All {
          /// 모든 약관을 읽었으며, 이에 동의해요
          internal static let title = L10n.tr("Localizable", "Onboarding.PolicyTerm.Agree.All.title", fallback: "모든 약관을 읽었으며, 이에 동의해요")
        }
        internal enum Location {
          /// [필수] 위치기반 서비스 이용약관 동의
          internal static let title = L10n.tr("Localizable", "Onboarding.PolicyTerm.Agree.Location.title", fallback: "[필수] 위치기반 서비스 이용약관 동의")
        }
        internal enum Privacy {
          /// [필수] 개인정보 수집/이용 동의
          internal static let title = L10n.tr("Localizable", "Onboarding.PolicyTerm.Agree.Privacy.title", fallback: "[필수] 개인정보 수집/이용 동의")
        }
        internal enum Service {
          /// [필수] 서비스 이용약관 동의
          internal static let title = L10n.tr("Localizable", "Onboarding.PolicyTerm.Agree.Service.title", fallback: "[필수] 서비스 이용약관 동의")
        }
      }
      internal enum Button {
        internal enum Next {
          /// 다음
          internal static let title = L10n.tr("Localizable", "Onboarding.PolicyTerm.Button.Next.title", fallback: "다음")
        }
      }
    }
  }
  internal enum Post {
    internal enum Date {
      /// 3/31 (금) AM 6:00
      internal static let placeHolder = L10n.tr("Localizable", "Post.Date.PlaceHolder", fallback: "3/31 (금) AM 6:00")
      /// 일시
      internal static let title = L10n.tr("Localizable", "Post.Date.Title", fallback: "일시")
    }
    internal enum Detail {
      internal enum NavBar {
        /// 등록
        internal static let rightItem = L10n.tr("Localizable", "Post.Detail.NavBar.RightItem", fallback: "등록")
        /// 게시글 작성
        internal static let title = L10n.tr("Localizable", "Post.Detail.NavBar.title", fallback: "게시글 작성")
      }
      internal enum NumParticipant {
        /// 모임 인원은 2명부터 최대 8명까지 가능해요! 
        internal static let maxError = L10n.tr("Localizable", "Post.Detail.NumParticipant.maxError", fallback: "모임 인원은 2명부터 최대 8명까지 가능해요! ")
        /// 모임 인원은 최소 2명 부터 가능해요!
        internal static let minError = L10n.tr("Localizable", "Post.Detail.NumParticipant.minError", fallback: "모임 인원은 최소 2명 부터 가능해요!")
        /// 인원
        internal static let title = L10n.tr("Localizable", "Post.Detail.NumParticipant.title", fallback: "인원")
      }
      internal enum TextContent {
        /// 함께할 러너들에게 하실 말씀이 있나요?
        internal static let placeHolder = L10n.tr("Localizable", "Post.Detail.TextContent.PlaceHolder", fallback: "함께할 러너들에게 하실 말씀이 있나요?")
        /// 하고 싶은 말(선택)
        internal static let title = L10n.tr("Localizable", "Post.Detail.TextContent.title", fallback: "하고 싶은 말(선택)")
      }
    }
    internal enum Modal {
      internal enum Time {
        /// 분
        internal static let minute = L10n.tr("Localizable", "Post.Modal.Time.minute", fallback: "분")
        /// 시간
        internal static let time = L10n.tr("Localizable", "Post.Modal.Time.time", fallback: "시간")
      }
    }
    internal enum Place {
      /// 모임 장소
      internal static let title = L10n.tr("Localizable", "Post.Place.Title", fallback: "모임 장소")
      internal enum Guide {
        /// * 정확한 위치는 참여 러너에게만 보여요!
        internal static let readable = L10n.tr("Localizable", "Post.Place.Guide.Readable", fallback: "* 정확한 위치는 참여 러너에게만 보여요!")
      }
    }
    internal enum Time {
      /// 모임은 최대 5시간까지 가능해요
      internal static let error = L10n.tr("Localizable", "Post.Time.Error", fallback: "모임은 최대 5시간까지 가능해요")
      /// 0시간 20분
      internal static let placeHolder = L10n.tr("Localizable", "Post.Time.PlaceHolder", fallback: "0시간 20분")
      /// 소요 시간
      internal static let title = L10n.tr("Localizable", "Post.Time.Title", fallback: "소요 시간")
    }
    internal enum Title {
      /// ex) A 직군 모여라, 묵언 러닝 하실 분, 마라톤 완주!
      internal static let placeHolder = L10n.tr("Localizable", "Post.Title.PlaceHolder", fallback: "ex) A 직군 모여라, 묵언 러닝 하실 분, 마라톤 완주!")
      /// 제목
      internal static let title = L10n.tr("Localizable", "Post.Title.Title", fallback: "제목")
    }
    internal enum WorkTime {
      /// 퇴근후
      internal static let afterWork = L10n.tr("Localizable", "Post.WorkTime.AfterWork", fallback: "퇴근후")
      /// 전체
      internal static let all = L10n.tr("Localizable", "Post.WorkTime.All", fallback: "전체")
      /// 출근전
      internal static let beforeWork = L10n.tr("Localizable", "Post.WorkTime.BeforeWork", fallback: "출근전")
      /// 휴일
      internal static let dayOff = L10n.tr("Localizable", "Post.WorkTime.DayOff", fallback: "휴일")
    }
    internal enum Write {
      internal enum NavBar {
        /// 게시글 작성
        internal static let title = L10n.tr("Localizable", "Post.Write.NavBar.title", fallback: "게시글 작성")
      }
    }
  }
  internal enum RunningPace {
    internal enum Average {
      /// 1km당 6~7분 러닝하는 평균 러너
      internal static let description = L10n.tr("Localizable", "RunningPace.average.description", fallback: "1km당 6~7분 러닝하는 평균 러너")
      /// 600 ~ 700
      internal static let title = L10n.tr("Localizable", "RunningPace.average.title", fallback: "600 ~ 700")
    }
    internal enum Beginner {
      /// 1km당 7~9분 러닝하는 입문 러너
      internal static let description = L10n.tr("Localizable", "RunningPace.beginner.description", fallback: "1km당 7~9분 러닝하는 입문 러너")
      /// 700 ~ 900
      internal static let title = L10n.tr("Localizable", "RunningPace.beginner.title", fallback: "700 ~ 900")
    }
    internal enum High {
      /// 1km당 4.5~6분 러닝하는 고수 러너
      internal static let description = L10n.tr("Localizable", "RunningPace.high.description", fallback: "1km당 4.5~6분 러닝하는 고수 러너")
      /// 430 ~ 600
      internal static let title = L10n.tr("Localizable", "RunningPace.high.title", fallback: "430 ~ 600")
    }
    internal enum Info {
      /// 1km당 달리는데 걸리는 시간에 대한
      /// 러닝 모임 페이스를 의미합니다.
      internal static let description = L10n.tr("Localizable", "RunningPace.info.description", fallback: "1km당 달리는데 걸리는 시간에 대한\n러닝 모임 페이스를 의미합니다.")
    }
    internal enum Master {
      /// 1km당 4.5분 미만으로 러닝하는 초고수 러너
      internal static let description = L10n.tr("Localizable", "RunningPace.master.description", fallback: "1km당 4.5분 미만으로 러닝하는 초고수 러너")
      /// 430 이하
      internal static let title = L10n.tr("Localizable", "RunningPace.master.title", fallback: "430 이하")
    }
    internal enum Register {
      /// 페이스는 1km당 달리는데 걸리는 시간에 대한
      /// 나의 러닝 페이스를 의미해요.
      internal static let subtitle = L10n.tr("Localizable", "RunningPace.register.subtitle", fallback: "페이스는 1km당 달리는데 걸리는 시간에 대한\n나의 러닝 페이스를 의미해요.")
      /// 나의 러닝 페이스를 선택해주세요!
      internal static let title = L10n.tr("Localizable", "RunningPace.register.title", fallback: "나의 러닝 페이스를 선택해주세요!")
      internal enum Cancel {
        internal enum Modal {
          /// 페이스 등록을 중단하시겠어요?
          internal static let title = L10n.tr("Localizable", "RunningPace.register.cancel.modal.title", fallback: "페이스 등록을 중단하시겠어요?")
        }
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
