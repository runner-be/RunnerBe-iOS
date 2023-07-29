# 🐝 러너비

## 프로젝트 소개

직장인 간 시간대/위치/직군/성별/나이 별로 러닝 모임을 결성하여 러닝을 뛸 수 있도록 돕는 서비스
- 기간 : 2022.05 ~ 2022.10, 배포 및 운영중
- 역할 : <br/>

  - [@SHIVVVPP - 김신우](https://github.com/SHIVVVPP)
  - 글 작성 (Post), 로그인(Onboarding, LoggedOut), 홈(Home), 스켈레톤 화면 처리(Skeleton)
 
  - [@yurrrri - 이유리](https://github.com/yurrrri)
  - 마이페이지 (MyPage 및 하위 도메인), 북마크(Bookmark), 러닝톡(Message)

- 팀 구성: iOS 개발자 2명, Android 개발자 2명, 백엔드 개발자 1명, 디자이너 1명, PM 1명
- Appstore: [https://apps.apple.com/kr/app/러너비/id1612604358](https://apps.apple.com/kr/app/%EB%9F%AC%EB%84%88%EB%B9%84/id1612604358)
- 브랜치
  - devleop_zoe: [@yurrrri - 이유리](https://github.com/yurrrri) 개발
  - develop: [@SHIVVVPP - 김신우](https://github.com/SHIVVVPP) 개발
  - main: 앱스토어 출시 버전과 동일한 브랜치 (앱스토어 배포 시 release -> main, release -> develop_zoe merge)
 
## Tech Stack

-   **언어**  : Swift
-   **UI**: UIKit, 코드 방식(SnapKit)
-   **아키텍처**  : MVVM + Coordinator
-   **비동기 처리**  : RxSwift, RxCocoa, DispatchQueue
-   **네트워킹**  : Moya
-   **기타**: Firebase Analytics/Crashlytics (유저 및 버그 리포트)
-   **협업**: Slack, Figma, Zeplin


## 아키텍처
### MVVM-C
<img width="500" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/e1c91eb4-5a41-4891-8fc6-3815db2edab5"/> <br/>

- **App**: AppCoordinator, AppContext(앱 전체에 공통적으로 적용되는 속성 혹은 기능 정의)
- **Common**: 앱 공통적으로 쓰이는 모달과 같은 컴포넌트, 모델, UI / 유용한 도구 모음 Util / Extension, Localization 등
- **Base**: 앱의 ViewController, ViewModel, Coordinator와 APIService에 공통적으로 사용되는 속성을 정의하며, Feature의 각 요소는 해당 Base 클래스를 상속하여 재사용성을 높임
- **Feature**: 회원가입 시 초기 진입하는 Onboarding 화면 / 탭바 기준으로 Home, BookMark, Message, MyPage로 분리
  - 각 Feature는 ViewController, ViewModel, Component, Coordinator를 가짐
  - **Component**: 화면 별로 필요한 ViewController, ViewModel을 소유하며 화면 전환 가능성이 있는 Component를 생성 및 전달
  - **Coordinator**: ViewController의 화면 전환 및 전환에 따른 추가 작업 로직 분리, 화면 계층 관리
  - **ViewModel**: Moya 기반의 APIService에서 통신한 내용과 UserDefaults의 localDB에 의존하여 데이터를 획득하며, View는 ViewModel을 바인딩함 (RxSwift, RxCocoa)

## Experience
- **앱 배포 시에 더미데이터가 앱에 그대로 남아있으면 베타서비스인것으로 인지하여 리젝**당할 수 있으므로, 더미데이터를 사전에 모두 삭제하고 배포를 올리거나 개발서버/배포서버를 따로 운영할 필요가 있다고 느꼈음
- **UIScrollView를 코드로 구현**하는 과정에서, 뷰의 구성요소에 따라 스크롤 영역이 달라짐을 이해하고 스크롤이 되지 않는다면 왜 스크롤이 되지 않았는지 분석하며 뷰 구성 및 크기에 따라 스크롤뷰를 다르게 적용할 수 있었던 계기가 되었음

## 주요 기능 설명
**1) 회원가입**
- 직장인이 타겟이므로, 성인 여부와 직군 정보를 회원가입 시 입력받습니다.

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/431af36e-6e60-4f5d-98a7-73f3b92765dc" />  <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/844b0a14-b067-4497-ac74-0b95d87d4f2d" /> <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/a686dc8d-63e5-4050-83b5-852b024576b1" /> <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/970566ee-e63b-45b1-ae45-8e305dbcbb7d" />

**2) 러닝 모임 개설 및 신청**
- 성별 / 나이대 / 위치 / 직군 별로 모임 개설 및 필터를 통한 신청이 가능합니다.

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/11be9c33-056e-4909-bc84-d1caebb8627d" /> <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/e444fdf4-0dac-442e-b2c3-9a41972fd453" /> <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/6852b95e-68c0-4b9d-9038-cd9186ff42dc" />
<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/43d9a655-ecb0-4b03-85d1-ee637f5b2985" />

**3) 러닝톡**
- 러닝 모임 참여자 간 실시간으로 소통할 수 있는 댓글 서비스입니다.

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/c87588f3-58f4-4410-818b-85d210a1e8c0" /> <img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/4a932f5d-810d-47c2-ad35-afc85a2d43cb" />

**4) 러닝 모임 관리 및 현황 확인**
- 러닝 모임 주최자는 러닝 참여자의 출석을 관리할 수 있으며, 참여자는 출석 여부를 확인할 수 있습니다.

<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/e6f6f73b-1a6e-48c1-9a58-b17cf467c263" />
<img width="200" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/7a2e641e-27c1-41de-a70a-9fe8ae9077b1" /> <img src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/0d1cc772-5726-44ad-98bd-b0da21084bc4" width="200" />
