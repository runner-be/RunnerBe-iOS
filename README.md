# 🐝 러너비

## 프로젝트 개요

직장인 간 시간대/위치/직군/성별/나이 별로 러닝 모임을 결성하여 러닝을 뛸 수 있도록 돕는 서비스

- 기간 : 2022.05 ~ 2022.10 개발, 서비스 운영중
- 팀 구성: Planner/PM, Designer, iOS, Android, Server
- SNS : https://www.instagram.com/runner_be_/
- Appstore: [https://apps.apple.com/kr/app/러너비/id1612604358](https://apps.apple.com/kr/app/%EB%9F%AC%EB%84%88%EB%B9%84/id1612604358)

## 개발 환경
**StoryBoard vs Code**

- 코드 방식으로 개발 (SnapKit)

**디자인패턴**

- MVVM-C 패턴

**라이브러리**

- Moya: API 통신에 사용
- RxSwift(+RxCocoa): 콜백에 따른 처리를 하지 않아도 되므로 코드가 깔끔해지며, 비동기 코드를 일관적으로 작성할 수 있음

## 역할

[@SHIVVVPP - 김신우](https://github.com/SHIVVVPP)
- develop 브랜치
- 글 작성 (Post), 로그인(Onboarding, LoggedOut), 홈(Home), 스켈레톤 화면 처리(Skeleton)

[@yurrrri - 이유리](https://github.com/yurrrri)
- devlop_zoe 브랜치
- 마이페이지 (MyPage 및 하위 도메인), 북마크(Bookmark), 러닝톡(Message)

## 주요 화면

<img width="250" alt="Untitled (12)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/fe2dea60-706d-4f7d-912f-1006cf8aa416">
<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/f8c78a0e-6b7d-48de-83ae-c8bdc07f05e5">
<img width="250" alt="Untitled (11)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/9914e734-f440-40a3-b9a7-021995acb6c5">

## 시연 영상
[![Video Label](http://img.youtube.com/vi/DrHK0fKFR9A/0.jpg)](https://youtu.be/DrHK0fKFR9A)

##  주요 기능

### ⭐️ 직장인 러닝 모임 개설 및 신청
- 위치, 시간대, 성별, 나이대, 직업 별 직장인 러닝 모임 및 신청 기능

### ⭐️ 모임 멤버간 소통 및 출석 기능
- 러닝톡을 통해 멤버간 소통이 가능하며, 리더는 본인을 포함한 멤버의 출석을 관리할 수 있음

## 디렉토리 구조

```bash

├── Runner-be
│   ├── Podfile
│   ├── Runner-be
│   │   ├── Ignore
│   │   │   └── Keys.swift
│   │   ├── Resources
│   │   │   ├── Assets+Generated.swift
│   │   │   ├── Assets.xcassets
│   │   │   ├── Font+.swift
│   │   │   ├── Fonts
│   │   │   ├── Fonts+Generated.swift
│   │   │   ├── Images.xcassets
│   │   │   ├── Localizable+Generated.swift
│   │   │   ├── Localization
│   │   │   │   ├── en.lproj
│   │   │   │   │   └── Localizable.strings
│   │   │   │   └── ko.lproj
│   │   │   │       └── Localizable.strings
│   │   │   └── UIColor+Zeplin.swift
│   │   ├── Runner-be.entitlements
│   │   ├── Sources
│   │   │   ├── App
│   │   │   │   ├── AppComponent.swift
│   │   │   │   ├── AppContext.swift
│   │   │   │   ├── AppCoordinator.swift
│   │   │   │   ├── AppDelegate.swift
│   │   │   │   ├── DeepLinkType.swift
│   │   │   │   └── SceneDelegate.swift
│   │   │   ├── Base
│   │   │   │   ├── BaseResponse.swift
│   │   │   │   ├── BaseViewController.swift
│   │   │   │   ├── BaseViewModel.swift
│   │   │   │   └── BasicCoordinator.swift
│   │   │   ├── Common             // 각 도메인: Compoennt, Coordinator, ViewController, ViewModel로 구성
│   │   │   │   ├── Component
│   │   │   │   │   ├── AlarmList
│   │   │   │   │   ├── PostDetail
│   │   │   │   │   │   ├── ApplicantListModal
│   │   │   │   │   │   ├── DetailOptionModal
│   │   │   │   │   │   │   ├── DeleteConfirmModal
│   │   │   │   │   │   ├── ReportModal
│   │   │   │   │   └── WritingPost
│   │   │   │   │       ├── Step1
│   │   │   │   │       │   ├── SelectDate
│   │   │   │   │       │   ├── SelectTime
│   │   │   │   │       ├── Step2
│   │   │   │   ├── CustomViews
│   │   │   │   ├── Model
│   │   │   │   └── Service
│   │   │   │       ├── API
│   │   │   │       ├── DynamicLinkService
│   │   │   │       ├── ImageUploadService
│   │   │   │       ├── KeyChain
│   │   │   │       ├── LocationService
│   │   │   │       ├── LoginService
│   │   │   │       ├── NotificationService
│   │   │   │       └── SignUpService
│   │   │   ├── Constants.swift
│   │   │   ├── Error
│   │   │   ├── Extensions
│   │   │   ├── LoggedOut
│   │   │   │   ├── EndPoint
│   │   │   ├── MainTabbar
│   │   │   │   ├── BookMark
│   │   │   │   ├── Home
│   │   │   │   │   ├── Filter
│   │   │   │   │   ├── Modal
│   │   │   │   │   │   ├── PostOrder
│   │   │   │   │   │   └── RunningTag
│   │   │   │   ├── Message
│   │   │   │   │   ├── MessageReport
│   │   │   │   │   ├── MessageRoom
│   │   │   │   ├── MyPage
│   │   │   │   │   ├── EditInfo
│   │   │   │   │   │   ├── JobChangeModal
│   │   │   │   │   │   └── NickNameChangeModal
│   │   │   │   │   ├── ManageAttendance
│   │   │   │   │   │   ├── ManageTimeExpiredModal
│   │   │   │   │   ├── Model
│   │   │   │   │   ├── Settings
│   │   │   │   │   │   ├── Config
│   │   │   │   │   │   ├── LogoutModal
│   │   │   │   │   │   ├── Maker
│   │   │   │   │   │   ├── SignoutModal
│   │   │   │   │   │   │   ├── SignoutCompletionModal
│   │   │   │   │   ├── TakePhotoModal
│   │   │   │   └── Onboarding
│   │   │   │       ├── Birth
│   │   │   │       ├── Gender
│   │   │   │       ├── JobGroup
│   │   │   │       ├── Model
│   │   │   │       ├── OnboardingCancelModal
│   │   │   │       ├── OnboardingCompletion
│   │   │   │       │   └── OnboardingCompletion
│   │   │   │       ├── OnboardingCover
│   │   │   │       └── PolicyTerm
│   │   │   │           ├── PolicyDetail
│   │   │   └── Utils
```
