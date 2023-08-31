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
- Appstore: https://apps.apple.com/kr/app/%EB%9F%AC%EB%84%88%EB%B9%84/id1612604358
- 브랜치
  - devleop_zoe: [@yurrrri - 이유리](https://github.com/yurrrri) 개발
  - develop: [@SHIVVVPP - 김신우](https://github.com/SHIVVVPP) 개발
  - main: 앱스토어 출시 버전과 동일한 브랜치 (앱스토어 배포 시 local 브랜치 release -> main, release -> develop_zoe merge)
 
## Tech Stack

-   **언어**  : Swift
-   **UI**: UIKit, 코드 방식(SnapKit)
-   **아키텍처**  : MVVM + Coordinator + Clean Architecture
-   **비동기 처리**  : RxSwift, DispatchQueue
-   **네트워킹**  : Moya
-   **기타**: Firebase Analytics/Crashlytics (유저 및 버그 리포트)
-   **협업**: Slack, Figma, Zeplin


## 아키텍처
### MVVM-C + Clean Architecture
(현재 앱스토어 버전에는 적용되지 않았기에 feature/refactor 브랜치에 적용되어있습니다.)

<img width="800" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/47d7e3ac-7feb-48e4-8953-18d2021ead8a"/> <br/>

- **Common**: 앱 공통적으로 쓰이는 모달과 같은 컴포넌트, 모델, CommonViews / 유용한 도구 모음 Util / Extension, Localization 등
- **Base**: 앱의 ViewController, ViewModel, Coordinator와 APIService에 공통적으로 사용되는 속성을 정의하며, Feature의 각 요소는 해당 Base 클래스를 상속하여 재사용성을 높임
- **Feature**: 회원가입 시 초기 진입하는 Onboarding 화면 / 탭바 기준으로 Home, BookMark, Message, MyPage로 분리
  - 각 Feature는 ViewController, ViewModel, Component, Coordinator를 가짐
  - 기존 MVVM 패턴에 Clean Architecture를 도입하여 Layer를 분리하고, ViewModel을 SRP(단일 책임 원칙)에 맞게 역할을 분리함으로써 유지보수를 용이하게 함
 
  **[Presentation Layer]**
  - **Component**: 화면 별로 필요한 ViewController, ViewModel을 소유하며 화면 전환 가능성이 있는 Component를 생성 및 전달
  - **Coordinator**: ViewController의 화면 전환 및 전환에 따른 추가 작업 로직 분리, 화면 계층 관리
  - **ViewModel**: Moya 기반의 APIService에서 통신한 내용과 UserDefaults의 localDB에 의존하여 데이터를 획득하며, View는 ViewModel을 바인딩함 (RxSwift, RxCocoa)
    - **Input/Output Modeling**: ViewModel의 Nested Type으로 Input 및 Output 구조체를 추가하여 View에서 ViewModel로 입력이 들어오는 부분은 Input, ViewModel에서 View로 출력되는 부분은 Output으로 분리하여 코드 가독성을 높임
 
  **[Domain Layer]**
  - **Entity**: Data Model
  - **UseCase**: Data Layer 계층의 APIService, KeyChainService와 소통함으로써 데이터 제공자로부터 데이터를 제공받고, ViewModel에게 제공하기 위한 데이터 가공 및 비즈니스 로직 수행
  - **Protocol**: Clean Architecture의 의존성 방향에 따르기 위해 Data Layer의 각 Service Class를 모듈화 및 추상화한 protocol을 생성하여 의존성을 주입함으로써 의존성이 역전되도록 함

  **[Data Layer]**
  - **APIService, KeyChainService**: 직접적으로 Entity를 사용하여 네트워크 통신, KeyChain 값 얻어오기 등을 통해 데이터를 UseCase에 제공하는 역할 수행


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
