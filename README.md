# 🐝 러너비


## 프로젝트 개요

직장인 간 시간대/위치/직군/성별/나이 별로 러닝 모임을 결성하여 러닝을 뛸 수 있도록 돕는 서비스

- 기간 : 2022.05 ~ 2022.10 개발, 서비스 운영중
- 팀 구성: Planner/PM, Designer, iOS, Android, Server
- SNS : https://www.instagram.com/runner_be_/
- Appstore: [https://apps.apple.com/kr/app/러너비/id1612604358](https://apps.apple.com/kr/app/%EB%9F%AC%EB%84%88%EB%B9%84/id1612604358)


## 개발 환경
**StoryBoard vs Code**

- 코드 방식으로 개발 (SnapKit)

**디자인패턴**

- MVVM-C 패턴

**라이브러리**

- Moya: API 통신에 사용
- RxSwift(+RxCocoa): 


## 주요 화면

<img width="250" alt="Untitled (12)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/fe2dea60-706d-4f7d-912f-1006cf8aa416">
<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/f8c78a0e-6b7d-48de-83ae-c8bdc07f05e5">
<img width="250" alt="Untitled (11)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/9914e734-f440-40a3-b9a7-021995acb6c5">

## 시연 영상
[![Video Label](http://img.youtube.com/vi/DrHK0fKFR9A/0.jpg)](https://youtu.be/DrHK0fKFR9A)

##  주요 기능

### ⭐️ 직장인 러닝 모임 개설 및 신청
- 위치, 시간대, 성별, 나이대, 직업 별 직장인 러닝 모임 및 신청 기능

### ⭐️ 모임 멤버간 소통 및 출석 기능
- 러닝톡을 통해 멤버간 소통이 가능하며, 리더는 본인을 포함한 멤버의 출석을 관리할 수 있음 

## 디렉토리 구조 및 역할

[@SHIVVVPP - 김신우](https://github.com/SHIVVVPP)
- develop 브랜치
- 글 작성 (Post), 로그인(Onboarding, LoggedOut), 홈(Home), 스켈레톤 화면 처리(Skeleton)

[@yurrrri - 이유리](https://github.com/yurrrri)
- devlop_zoe 브랜치
- 마이페이지 (MyPage 및 하위 도메인), 북마크(Bookmark), 러닝톡(Message)



<details><summary>디렉토리 구조 보기
</summary>

```bash
├── Pods
├── Runner-be
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── GoogleService-Info.plist
│   ├── Ignore
│   │   └── Keys.swift         //gitignore를 통해 무시되어 올라갈 보안 관련 코드
│   ├── Info.plist
│   ├── Pods-Runner-be-acknowledgements.plist
│   ├── Resources               //이미지, Localization.strings, Font 관련 리소스 폴더
│   │   ├── Assets+Generated.swift
│   │   ├── Assets.xcassets
│   │   ├── Font+.swift
│   │   ├── Fonts
│   │   ├── Fonts+Generated.swift
│   │   ├── Images.xcassets
│   │   ├── Localizable+Generated.swift
│   │   ├── Localization
│   │   │   └── ko.lproj
│   │   │       └── Localizable.strings
│   │   └── UIColor+Zeplin.swift
│   ├── Runner-be.entitlements
│   ├── Sources
│   │   ├── App
│   │   │   ├── AppComponent.swift
│   │   │   ├── AppContext.swift
│   │   │   ├── AppCoordinator.swift
│   │   │   ├── AppDelegate.swift
│   │   │   ├── DeepLinkType.swift
│   │   │   └── SceneDelegate.swift
│   │   ├── Base
│   │   │   ├── BaseResponse.swift
│   │   │   ├── BaseViewController.swift
│   │   │   ├── BaseViewModel.swift
│   │   │   └── BasicCoordinator.swift
│   │   ├── Common
│   │   │   ├── Component
│   │   │   │   ├── AlarmList
│   │   │   │   │   ├── AlarmCell
│   │   │   │   │   │   ├── AlarmCell.swift
│   │   │   │   │   │   └── AlarmListSection.swift
│   │   │   │   │   ├── AlarmListComponent.swift
│   │   │   │   │   ├── AlarmListCoordinator.swift
│   │   │   │   │   ├── AlarmListViewController.swift
│   │   │   │   │   └── AlarmListViewModel.swift
│   │   │   │   ├── PostDetail
│   │   │   │   │   ├── ApplicantListModal
│   │   │   │   │   │   ├── ApplicantListModalComponent.swift
│   │   │   │   │   │   ├── ApplicantListModalCoordinator.swift
│   │   │   │   │   │   ├── ApplicantListModalViewController.swift
│   │   │   │   │   │   ├── ApplicantListModalViewModel.swift
│   │   │   │   │   │   └── View
│   │   │   │   │   │       ├── UserInfoAcceptableCell.swift
│   │   │   │   │   │       └── UserInfoAcceptableDataSource.swift
│   │   │   │   │   ├── Config
│   │   │   │   │   │   └── PostDetailViewConfigItem.swift
│   │   │   │   │   ├── DetailOptionModal
│   │   │   │   │   │   ├── DeleteConfirmModal
│   │   │   │   │   │   │   ├── DeleteConfirmModalComponent.swift
│   │   │   │   │   │   │   ├── DeleteConfirmModalCoordinator.swift
│   │   │   │   │   │   │   ├── DeleteConfirmModalViewController.swift
│   │   │   │   │   │   │   └── DeleteConfirmModalViewModel.swift
│   │   │   │   │   │   ├── DetailOptionModalComponent.swift
│   │   │   │   │   │   ├── DetailOptionModalCoordinator.swift
│   │   │   │   │   │   ├── DetailOptionModalViewController.swift
│   │   │   │   │   │   └── DetailOptionModalViewModel.swift
│   │   │   │   │   ├── PostDetailComponent.swift
│   │   │   │   │   ├── PostDetailCoordinator.swift
│   │   │   │   │   ├── PostDetailViewController.swift
│   │   │   │   │   ├── PostDetailViewModel.swift
│   │   │   │   │   ├── ReportModal
│   │   │   │   │   │   ├── ReportModalComponent.swift
│   │   │   │   │   │   ├── ReportModalCoordinator.swift
│   │   │   │   │   │   ├── ReportModalViewController.swift
│   │   │   │   │   │   └── ReportModalViewModel.swift
│   │   │   │   │   └── View
│   │   │   │   │       ├── DetailInfoView.swift
│   │   │   │   │       ├── DetailMapView.swift
│   │   │   │   │       ├── DetailTitleView.swift
│   │   │   │   │       ├── PostDetailFooter.swift
│   │   │   │   │       ├── UserInfoHeader.swift
│   │   │   │   │       └── UserInfoWithSingleDivider.swift
│   │   │   │   └── WritingPost
│   │   │   │       ├── Model
│   │   │   │       │   └── WritingPostData.swift
│   │   │   │       ├── Step1
│   │   │   │       │   ├── SelectDate
│   │   │   │       │   │   ├── SelectDateModalComponent.swift
│   │   │   │       │   │   ├── SelectDateModalCoordinator.swift
│   │   │   │       │   │   ├── SelectDateModalViewController.swift
│   │   │   │       │   │   └── SelectDateModalViewModel.swift
│   │   │   │       │   ├── SelectTime
│   │   │   │       │   │   ├── SelectTimeModalComponent.swift
│   │   │   │       │   │   ├── SelectTimeModalCoordinator.swift
│   │   │   │       │   │   ├── SelectTimeModalViewController.swift
│   │   │   │       │   │   └── SelectTimeModalViewModel.swift
│   │   │   │       │   ├── WritingMainPostComponent.swift
│   │   │   │       │   ├── WritingMainPostCoordinator.swift
│   │   │   │       │   ├── WritingMainPostViewController.swift
│   │   │   │       │   └── WritingMainPostViewModel.swift
│   │   │   │       ├── Step2
│   │   │   │       │   ├── View
│   │   │   │       │   │   └── SummaryMainPostView.swift
│   │   │   │       │   ├── WritingDetailPostComponent.swift
│   │   │   │       │   ├── WritingDetailPostCoordinator.swift
│   │   │   │       │   ├── WritingDetailPostViewController.swift
│   │   │   │       │   └── WritingDetailPostViewModel.swift
│   │   │   │       └── View
│   │   │   │           ├── WritingDateView.swift
│   │   │   │           ├── WritingPlaceView.swift
│   │   │   │           ├── WritingTimeView.swift
│   │   │   │           └── WritingTitleView.swift
│   │   │   ├── CustomViews
│   │   │   │   ├── CheckBox
│   │   │   │   │   └── CheckBoxView.swift
│   │   │   │   ├── CommonSelectViews
│   │   │   │   │   ├── SelectAgeView.swift
│   │   │   │   │   ├── SelectBaseView.swift
│   │   │   │   │   ├── SelectGenderView.swift
│   │   │   │   │   ├── SelectJobView.swift
│   │   │   │   │   ├── SelectNumParticipantView.swift
│   │   │   │   │   ├── SelectPlaceView.swift
│   │   │   │   │   ├── SelectTextContentView.swift
│   │   │   │   │   └── TextFieldWithButton.swift
│   │   │   │   ├── IconTextButtonGroup
│   │   │   │   │   └── IconTextButtonGroup.swift
│   │   │   │   ├── JobGroupCollection
│   │   │   │   │   ├── JobGroupCollectionViewCell.swift
│   │   │   │   │   ├── JobGroupCollectionViewLayout.swift
│   │   │   │   │   └── JobGroupView.swift
│   │   │   │   ├── Label
│   │   │   │   │   ├── BadgeLabel.swift
│   │   │   │   │   ├── Bubble
│   │   │   │   │   │   └── BubbleLabel.swift
│   │   │   │   │   ├── IconLabel.swift
│   │   │   │   │   ├── OnOff
│   │   │   │   │   │   ├── OnOffLabel.swift
│   │   │   │   │   │   └── OnOffLabelGroup.swift
│   │   │   │   │   └── RunnerBadge.swift
│   │   │   │   ├── Map
│   │   │   │   │   ├── PostAnnotationView.swift
│   │   │   │   │   └── RunnerBeMapView.swift
│   │   │   │   ├── NavigationBar
│   │   │   │   │   └── RunnerBeNavBar.swift
│   │   │   │   ├── PostCell
│   │   │   │   │   ├── BasicPostCell.swift
│   │   │   │   │   ├── BasicPostDataSource.swift
│   │   │   │   │   ├── BasicPostInfoView.swift
│   │   │   │   │   └── PostCellConfig.swift
│   │   │   │   ├── SegmentedControl
│   │   │   │   │   ├── SegmentedControl.swift
│   │   │   │   │   └── SegmentedControlDelegate.swift
│   │   │   │   ├── Skeleton
│   │   │   │   │   └── Skeleton.swift
│   │   │   │   ├── Slider
│   │   │   │   │   ├── Follower
│   │   │   │   │   │   ├── BubbleFollower.swift
│   │   │   │   │   │   └── RunnerbeSliderHandleFollower.swift
│   │   │   │   │   ├── Handle
│   │   │   │   │   │   ├── CircularHandle.swift
│   │   │   │   │   │   └── SliderHandle.swift
│   │   │   │   │   ├── LabelGroup
│   │   │   │   │   │   ├── BasicSliderLabelGroup.swift
│   │   │   │   │   │   └── SliderLabelGroup.swift
│   │   │   │   │   ├── Slider.swift
│   │   │   │   │   └── SliderDelegate.swift
│   │   │   │   ├── TextField
│   │   │   │   │   └── TextFieldWithPadding.swift
│   │   │   │   └── UserInfo
│   │   │   │       └── UserInfoView.swift
│   │   │   ├── Model
│   │   │   │   ├── Alarm.swift
│   │   │   │   ├── FilterType.swift
│   │   │   │   ├── Mail
│   │   │   │   │   └── Mail.swift
│   │   │   │   ├── Policy
│   │   │   │   │   └── PolicyType.swift
│   │   │   │   ├── Post.swift
│   │   │   │   ├── PostFilter.swift
│   │   │   │   ├── PostState.swift
│   │   │   │   ├── PostingForm.swift
│   │   │   │   ├── Response
│   │   │   │   │   └── BasicResponse.swift
│   │   │   │   ├── RunningTag.swift
│   │   │   │   └── UserInfo
│   │   │   │       ├── Gender.swift
│   │   │   │       ├── Job.swift
│   │   │   │       └── User.swift
│   │   │   └── Service
│   │   │       ├── API
│   │   │       │   ├── APIResponse
│   │   │       │   │   ├── DetailPostResponse.swift
│   │   │       │   │   └── PostResponse.swift
│   │   │       │   ├── BaseAPI.swift
│   │   │       │   ├── LoginAPIService
│   │   │       │   │   ├── BasicLoginAPIService.swift
│   │   │       │   │   └── LoginAPIService.swift
│   │   │       │   ├── MailingAPIService
│   │   │       │   │   ├── BasicMailingAPIService.swift
│   │   │       │   │   ├── EmailAPI.swift
│   │   │       │   │   └── MailingAPIService.swift
│   │   │       │   ├── PolicyAPIService
│   │   │       │   │   ├── BasicPolicyAPIService.swift
│   │   │       │   │   ├── PolicyAPI.swift
│   │   │       │   │   └── PolicyAPIService.swift
│   │   │       │   ├── PostAPIService
│   │   │       │   │   ├── BasicPostAPIService.swift
│   │   │       │   │   ├── PostAPI.swift
│   │   │       │   │   └── PostAPIService.swift
│   │   │       │   ├── SignupAPIService
│   │   │       │   │   ├── BasicSignupAPIService.swift
│   │   │       │   │   ├── SignupAPI.swift
│   │   │       │   │   └── SignupAPIService.swift
│   │   │       │   └── UserAPIService
│   │   │       │       ├── BasicUserAPIService.swift
│   │   │       │       ├── UserAPI.swift
│   │   │       │       └── UserAPIService.swift
│   │   │       ├── DynamicLinkService
│   │   │       │   ├── BasicDynamicLinkService.swift
│   │   │       │   └── DynamicLinkService.swift
│   │   │       ├── ImageUploadService
│   │   │       │   ├── BasicImageUploadService.swift
│   │   │       │   └── ImageUploadService.swift
│   │   │       ├── KeyChain
│   │   │       │   ├── BasicLoginKeyChainService.swift
│   │   │       │   ├── BasicUserKeyChainService.swift
│   │   │       │   ├── LoginKeyChainService.swift
│   │   │       │   └── UserKeyChainService.swift
│   │   │       ├── LocationService
│   │   │       │   ├── BasicLocationService.swift
│   │   │       │   └── LocationService.swift
│   │   │       ├── LoginService
│   │   │       │   ├── BasicLoginService.swift
│   │   │       │   ├── LoginService.swift
│   │   │       │   └── SocialLoginService
│   │   │       │       ├── KakaoLoginService.swift
│   │   │       │       ├── NaverLoginService.swift
│   │   │       │       └── SocialLoginService.swift
│   │   │       ├── NotificationService
│   │   │       │   ├── BasicRBNotificationService.swift
│   │   │       │   └── RBNotificationService.swift
│   │   │       └── SignUpService
│   │   │           ├── BasicSignupService.swift
│   │   │           ├── RendomNickNameGenerator
│   │   │           │   └── RandomNickNameGenerator.swift
│   │   │           └── SignupService.swift
│   │   ├── Constants.swift
│   │   ├── Error
│   │   │   └── JSONError.swift
│   │   ├── Extensions            // extension 파일 모음
│   │   │   ├── Asset+
│   │   │   │   └── Assets+.swift
│   │   │   ├── CG
│   │   │   │   ├── CGFloat+.swift
│   │   │   │   ├── CGPoint+.swift
│   │   │   │   └── CGRect+.swift
│   │   │   ├── MapView+
│   │   │   │   ├── MKMapRect+.swift
│   │   │   │   └── MKMapView+.swift
│   │   │   ├── Rx+
│   │   │   │   └── Rx+Response.swift
│   │   │   ├── String+
│   │   │   │   ├── String+SHA256.swift
│   │   │   │   ├── String+Subscript.swift
│   │   │   │   └── String+regex.swift
│   │   │   └── View+
│   │   │       ├── NSMutableAttributedString+Style.swift
│   │   │       ├── UIButton+.swift
│   │   │       ├── UIImage+Resize.swift
│   │   │       ├── UILabel+Extension.swift
│   │   │       ├── UIScreen+.swift
│   │   │       ├── UIStackView+.swift
│   │   │       ├── UITabbarController+.swift
│   │   │       └── UIView+.swift
│   │   ├── LoggedOut
│   │   │   ├── EndPoint
│   │   │   │   └── LoginAPI.swift
│   │   │   ├── LoggedOutComponent.swift
│   │   │   ├── LoggedOutCoordinator.swift
│   │   │   ├── LoggedOutViewController.swift
│   │   │   ├── LoggedOutViewModel.swift
│   │   │   └── Model
│   │   │       ├── LoginAPIResult.swift
│   │   │       ├── LoginToken.swift
│   │   │       ├── LoginType.swift
│   │   │       ├── SocialLoginResult.swift
│   │   │       └── SocialLoginType.swift
│   │   ├── MainTabbar
│   │   │   ├── BookMark
│   │   │   │   ├── BookMarkComponent.swift
│   │   │   │   ├── BookMarkCoordinator.swift
│   │   │   │   ├── BookMarkViewController.swift
│   │   │   │   └── BookMarkViewModel.swift
│   │   │   ├── CommonConfig
│   │   │   │   └── UserConfig.swift
│   │   │   ├── Home
│   │   │   │   ├── Filter
│   │   │   │   │   ├── HomeFilterComponent.swift
│   │   │   │   │   ├── HomeFilterCoordinator.swift
│   │   │   │   │   ├── HomeFilterViewController.swift
│   │   │   │   │   └── HomeFilterViewModel.swift
│   │   │   │   ├── HomeComponent.swift
│   │   │   │   ├── HomeCoordinator.swift
│   │   │   │   ├── HomeViewController.swift
│   │   │   │   ├── HomeViewModel.swift
│   │   │   │   ├── Modal
│   │   │   │   │   ├── PostOrder
│   │   │   │   │   │   ├── PostListOrder.swift
│   │   │   │   │   │   ├── PostOrderModalComponent.swift
│   │   │   │   │   │   ├── PostOrderModalCoordinator.swift
│   │   │   │   │   │   ├── PostOrderModalViewController.swift
│   │   │   │   │   │   └── PostOrderModalViewModel.swift
│   │   │   │   │   └── RunningTag
│   │   │   │   │       ├── RunningTagModalComponent.swift
│   │   │   │   │       ├── RunningTagModalCoordinator.swift
│   │   │   │   │       ├── RunningTagModalViewController.swift
│   │   │   │   │       └── RunningTagModalViewModel.swift
│   │   │   │   └── View
│   │   │   │       └── SelectionLabel.swift
│   │   │   ├── MainTabComponent.swift
│   │   │   ├── MainTabbarController.swift
│   │   │   ├── MainTabbarCoordinator.swift
│   │   │   ├── MainTabbarViewModel.swift
│   │   │   ├── Message
│   │   │   │   ├── Cell
│   │   │   │   │   ├── MessageChatLeftCell.swift
│   │   │   │   │   ├── MessageChatRightCell.swift
│   │   │   │   │   └── MessageTableViewCell.swift
│   │   │   │   ├── MessageComponent.swift
│   │   │   │   ├── MessageCoordinator.swift
│   │   │   │   ├── MessageReport
│   │   │   │   │   ├── MessageReportComponent.swift
│   │   │   │   │   ├── MessageReportCoordinator.swift
│   │   │   │   │   ├── MessageReportViewController.swift
│   │   │   │   │   └── MessageReportViewModel.swift
│   │   │   │   ├── MessageRoom
│   │   │   │   │   ├── MessageRoomComponent.swift
│   │   │   │   │   ├── MessageRoomCoordinator.swift
│   │   │   │   │   ├── MessageRoomViewController.swift
│   │   │   │   │   └── MessageRoomViewModel.swift
│   │   │   │   ├── MessageViewController.swift
│   │   │   │   ├── MessageViewModel.swift
│   │   │   │   ├── Model
│   │   │   │   │   ├── GetMessageListResponse.swift
│   │   │   │   │   ├── GetMessageRoomResponse.swift
│   │   │   │   │   ├── Message.swift
│   │   │   │   │   ├── PostMessageReportRequest.swift
│   │   │   │   │   └── PostMessageRequest.swift
│   │   │   │   ├── Network
│   │   │   │   │   ├── MessageAPI.swift
│   │   │   │   │   └── MessageAPIService.swift
│   │   │   │   └── View
│   │   │   │       ├── MessageChatTableViewCell.swift
│   │   │   │       └── MessagePostView.swift
│   │   │   ├── MyPage
│   │   │   │   ├── Config
│   │   │   │   │   ├── MyPageParticipatePostConfig.swift
│   │   │   │   │   ├── MyPagePostConfig.swift
│   │   │   │   │   └── MyPagePostDataSource.swift
│   │   │   │   ├── EditInfo
│   │   │   │   │   ├── EditInfoComponent.swift
│   │   │   │   │   ├── EditInfoCoordinator.swift
│   │   │   │   │   ├── EditInfoDataManager.swift
│   │   │   │   │   ├── EditInfoViewController.swift
│   │   │   │   │   ├── EditInfoViewModel.swift
│   │   │   │   │   ├── JobChangeModal
│   │   │   │   │   │   ├── JobChangeModalComponent.swift
│   │   │   │   │   │   ├── JobChangeModalCoordinator.swift
│   │   │   │   │   │   ├── JobChangeModalViewController.swift
│   │   │   │   │   │   └── JobChangeModalViewModel.swift
│   │   │   │   │   └── NickNameChangeModal
│   │   │   │   │       ├── NickNameChangeModalComponent.swift
│   │   │   │   │       ├── NickNameChangeModalCoordinator.swift
│   │   │   │   │       ├── NickNameChangeModalViewController.swift
│   │   │   │   │       └── NickNameChangeModalViewModel.swift
│   │   │   │   ├── ManageAttendance
│   │   │   │   │   ├── Cell
│   │   │   │   │   │   └── ManageAttendanceCell.swift
│   │   │   │   │   ├── ManageAttendanceComponent.swift
│   │   │   │   │   ├── ManageAttendanceCoordinator.swift
│   │   │   │   │   ├── ManageAttendanceViewController.swift
│   │   │   │   │   ├── ManageAttendanceViewModel.swift
│   │   │   │   │   ├── ManageTimeExpiredModal
│   │   │   │   │   │   ├── ManageTimeExpiredModalComponent.swift
│   │   │   │   │   │   ├── ManageTimeExpiredModalCoordinator.swift
│   │   │   │   │   │   ├── ManageTimeExpiredModalViewModel.swift
│   │   │   │   │   │   └── ManageTimeExpiredViewController.swift
│   │   │   │   │   └── View
│   │   │   │   │       └── ManageAttendanceResultView.swift
│   │   │   │   ├── Model
│   │   │   │   │   ├── GetMyPageResponse.swift
│   │   │   │   │   ├── PatchAttendanceRequest.swift
│   │   │   │   │   ├── PatchJobRequest.swift
│   │   │   │   │   └── PatchProfileRequest.swift
│   │   │   │   ├── MyPageComponent.swift
│   │   │   │   ├── MyPageCoordinator.swift
│   │   │   │   ├── MyPageViewController.swift
│   │   │   │   ├── MyPageViewModel.swift
│   │   │   │   ├── Settings
│   │   │   │   │   ├── Config
│   │   │   │   │   │   └── SettingConfigItems.swift
│   │   │   │   │   ├── LogoutModal
│   │   │   │   │   │   ├── LogoutModalComponent.swift
│   │   │   │   │   │   ├── LogoutModalCoordinator.swift
│   │   │   │   │   │   ├── LogoutModalViewController.swift
│   │   │   │   │   │   └── LogoutModalViewModel.swift
│   │   │   │   │   ├── Maker
│   │   │   │   │   │   ├── MakerComponent.swift
│   │   │   │   │   │   ├── MakerCoordinator.swift
│   │   │   │   │   │   ├── MakerViewController.swift
│   │   │   │   │   │   ├── MakerViewModel.swift
│   │   │   │   │   │   └── View
│   │   │   │   │   │       └── MakerView.swift
│   │   │   │   │   ├── SettingsComponent.swift
│   │   │   │   │   ├── SettingsCoordinator.swift
│   │   │   │   │   ├── SettingsDataManager.swift
│   │   │   │   │   ├── SettingsViewController.swift
│   │   │   │   │   ├── SettingsViewModel.swift
│   │   │   │   │   ├── SignoutModal
│   │   │   │   │   │   ├── SignoutCompletionModal
│   │   │   │   │   │   │   ├── SignoutCompletionModalComponent.swift
│   │   │   │   │   │   │   ├── SignoutCompletionModalCoordinator.swift
│   │   │   │   │   │   │   ├── SignoutCompletionModalViewController.swift
│   │   │   │   │   │   │   └── SignoutCompletionModalViewModel.swift
│   │   │   │   │   │   ├── SignoutModalComponent.swift
│   │   │   │   │   │   ├── SignoutModalCoordinator.swift
│   │   │   │   │   │   ├── SignoutModalViewController.swift
│   │   │   │   │   │   └── SignoutModalViewModel.swift
│   │   │   │   │   └── View
│   │   │   │   │       └── SettingCell.swift
│   │   │   │   ├── TakePhotoModal
│   │   │   │   │   ├── TakePhotoModalComponent.swift
│   │   │   │   │   ├── TakePhotoModalCoordinator.swift
│   │   │   │   │   ├── TakePhotoModalViewController.swift
│   │   │   │   │   └── TakePhotoModalViewModel.swift
│   │   │   │   └── View
│   │   │   │       ├── MyInfoView.swift
│   │   │   │       ├── MyInfoViewWithChevron.swift
│   │   │   │       ├── MyPageParticipateCell.swift
│   │   │   │       └── MyPagePostCell.swift
│   │   │   └── Onboarding
│   │   │       ├── Birth
│   │   │       │   ├── BirthComponent.swift
│   │   │       │   ├── BirthCoordinator.swift
│   │   │       │   ├── BirthViewController.swift
│   │   │       │   └── BirthViewModel.swift
│   │   │       ├── Gender
│   │   │       │   ├── SelectGenderComponent.swift
│   │   │       │   ├── SelectGenderCoordinator.swift
│   │   │       │   ├── SelectGenderViewController.swift
│   │   │       │   └── SelectGenderViewModel.swift
│   │   │       ├── JobGroup
│   │   │       │   ├── SelectJobGroupComponent.swift
│   │   │       │   ├── SelectJobGroupCoordinator.swift
│   │   │       │   ├── SelectJobGroupViewController.swift
│   │   │       │   └── SelectJobGroupViewModel.swift
│   │   │       ├── Model
│   │   │       │   └── Signup
│   │   │       │       ├── SignupAPIResult.swift
│   │   │       │       └── SignupForm.swift
│   │   │       ├── OnboardingCancelModal
│   │   │       │   ├── OnboardingCancelModalComponent.swift
│   │   │       │   ├── OnboardingCancelModalCoordinator.swift
│   │   │       │   ├── OnboardingCancelModalViewController.swift
│   │   │       │   └── OnboardingCancelModalViewModel.swift
│   │   │       ├── OnboardingCompletion
│   │   │       │   └── OnboardingCompletion
│   │   │       │       ├── OnboardingCompletionComponent.swift
│   │   │       │       ├── OnboardingCompletionCoordinator.swift
│   │   │       │       ├── OnboardingCompletionViewController.swift
│   │   │       │       └── OnboardingCompletionViewModel.swift
│   │   │       ├── OnboardingCover
│   │   │       │   └── NeedOnboardingCover
│   │   │       │       ├── OnboardingCoverComponent.swift
│   │   │       │       ├── OnboardingCoverCoordinator.swift
│   │   │       │       ├── OnboardingCoverViewController.swift
│   │   │       │       └── OnboardingCoverViewModel.swift
│   │   │       └── PolicyTerm
│   │   │           ├── PolicyDetail
│   │   │           │   ├── PolicyDetailComponent.swift
│   │   │           │   ├── PolicyDetailCoordinator.swift
│   │   │           │   ├── PolicyDetailViewController.swift
│   │   │           │   └── PolicyDetailViewModel.swift
│   │   │           ├── PolicyTermComponent.swift
│   │   │           ├── PolicyTermCoordinator.swift
│   │   │           ├── PolicyTermViewController.swift
│   │   │           └── PolicyTermViewModel.swift
│   │   ├── UserInfo.swift
│   │   └── Utils              // 앱에서 자주 쓰이는 도구 파일 모음
│   │       ├── DateUtil
│   │       │   ├── DateFormat.swift
│   │       │   ├── DateStamp.swift
│   │       │   └── DateUtil.swift
│   │       ├── EditProfileType.swift
│   │       ├── Log
│   │       │   └── Log.swift
│   │       └── MoyaPlugin
│   │           └── VerbosePlugin.swift
│   └── ko.lproj
│       ├── LaunchScreen.storyboard
│       └── LaunchScreen.strings
```
</details>


## 트러블 슈팅 & 개선사항
