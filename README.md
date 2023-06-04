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

## 디렉토리 구조 및 역할

[@SHIVVVPP - 김신우](https://github.com/SHIVVVPP)
- develop 브랜치
- 글 작성 (Post), 로그인(Onboarding, LoggedOut), 홈(Home), 스켈레톤 화면 처리(Skeleton)

[@yurrrri - 이유리](https://github.com/yurrrri)
- devlop_zoe 브랜치
- 마이페이지 (MyPage 및 하위 도메인), 북마크(Bookmark), 러닝톡(Message)


## 트러블 슈팅 & 개선사항

<details><summary>1. 작성한 글의 UICollectionView cell의 ‘출석 관리하기’ 버튼을 누르면 해당 게시글의 출석 관리하기 화면에 한번만 진입해야하나, 여러 번 진입되는 이슈
</summary>
<br/>
  <img width="250" alt="Untitled (13)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/494fcf75-8dbe-4c9c-8bb6-4cb5f47a37fa"> <br/>
  
❗️ **문제원인**
- cell의 버튼을 누른 후 dispose할 때, ViewController의 DisposeBag을 사용하여 dispose했기 때문에, cell 버튼 동작에 대한 구독이 종료되지 않고 계속 메모리가 살아있기 때문이 원인

✅ **해결**
- cell 버튼 클릭은 각 cell마다의 tap이기때문에 종료 시점이 cell이 기준이 되어야하므로, cell에 별도의 DisposeBag 생성 후,dispose시 cell의 DisposeBag을 사용하여 종료함으로써 셀 개별의 메모리를 관리할 수 있도록 수정하였음
<img width="600" alt="Untitled (14)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/02c98ce2-c118-4b60-a27d-47a245fb6ab8"> <br/>
</details>

<details><summary>2. UIScrollView에 View, UICollectionView를 넣었을 때 리스트가 끝까지 스크롤되지 않는 이슈
</summary>
<br/>
  <img width="250" alt="Untitled (13)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/494fcf75-8dbe-4c9c-8bb6-4cb5f47a37fa"> <br/>


❗️ **문제원인**
https://developer.apple.com/documentation/uikit/uiscrollview 에 따르면
'작성한 글’과 ‘참여 러닝’ 컬렉션뷰는 API와 통신 성공함에 따라 contentSize가 유동적이므로, UIScrollView가 스크롤하는 범위인 contentSize가 명확히 정해져있지 않아 스크롤이 되지 않았던 것으로 확인됨

✅ **해결**
- 처음 마이페이지를 클릭했을 때 ‘작성한 글’을 불러오므로, ‘작성한 글’을 API에서 불러오는 시점에UICollectionView의 높이를 ‘작성한 글’의 UICollectionView의 contentSize의 높이를 기준으로 지정한 다음,
<img width="515" alt="Untitled (15)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/ae71b63b-0718-4344-861e-be58124486ca">

- ‘작성한 글’과 ‘참여 러닝’ 버튼을 클릭하여 API로부터 내용이 load 될 때마다 각 컬렉션뷰의 높이를 해당 뷰의 contentSize로 지정하였음
<img width="515" alt="Untitled (16)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/988af67b-1257-4767-b070-9b0df91dc356"> <br/>
  
</details>

<details><summary>3. 키보드가 채팅방 하단부를 가리는 불편함
</summary>
<br/>
<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/5ecf8532-dfc1-4aa1-81aa-8173b6cb44ea" /> <br/>
  
아래 내용이 보이지 않아 사용자 입장에서 불편한 UI일 것으로 생각되어 개선하고자 하였음 <br/>
**💡 Idea**

다른분들은 어떻게 해결했는지 레퍼런스를 찾아봤다.
**보통 키보드가 등장할 때 뷰의 y 좌표를 위로 조정하고, 사라질 때 다시 아래로 내리는 방식으로 하는것같았다.**
이 방식은 원래 텍스트뷰를 위로 올릴 때 사용하던 방식이기는 했는데, 아래 내용까지 보일 수 있도록 다시 적용해보기로 했다. <br/>

✅ **해결**

**1) 처음 테이블뷰도 마찬가지로 frame의 y를 뺐다가 더하는 쪽으로 했는데 아래와 같은 결과가 발생했다.**
<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/8147520f-68b2-4265-ba12-7f8584b6dd48/>

```swift
override func viewDidLoad() {

 	NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

}

@objc func keyboardWillShow(_ notification: Notification) { // keyboardFrameEndUserInfoKey : 키보드가 차지하는 frame의 CGRect값 반환
if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue {
let keyboardRectangle = keyboardFrame.cgRectValue
let keyboardHeight = keyboardRectangle.height
        chatBackGround.frame.origin.y -= (keyboardHeight - AppContext.shared.safeAreaInsets.bottom)
        messageChatTableView.frame.origin.y -= (keyboardHeight - AppContext.shared.safeAreaInsets.bottom)
    }
}

@objc func keyboardWillHide(_ notification: Notification) {
if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue {
let keyboardRectangle = keyboardFrame.cgRectValue
let keyboardHeight = keyboardRectangle.height
        chatBackGround.frame.origin.y += (keyboardHeight - AppContext.shared.safeAreaInsets.bottom)
        messageChatTableView.frame.origin.y += (keyboardHeight - AppContext.shared.safeAreaInsets.bottom)
    }
}
```

- **바라는 결과는 메시지의 마지막 내용이 입력창 위로 자연스럽게 스크롤되면서 이와동시에 카카오톡처럼 맨 처음 메시지 끝까지 수동으로 스크롤할 수 있는 형태였다. 다만 이 코드는 채팅 리스트의 y값 자체를 위로 올려버리는거라서 저렇게 상단바 위로까지 올라가고 + 메시지가 위로 스크롤할정도로 많지가 않아서 올라갈 필요도 없었다.**
- 일단 기존 카카오톡과 UI가 유사하니, 카카오톡 채팅방은 어떻게 만들어졌나 살펴보니, 다음과 같았다

<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/1fce2c19-a3ac-4c30-a09c-3ab9b7c6e482 "/>
<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/e2fd53ea-2827-4ce7-998a-16334b92b7ff" />


- 채팅 입력 시 키보드가 올라가면, 키보드랑 채팅 리스트가 함께 올라가는데, 이때 위 상단바는 채팅 리스트 위에 떠있는 형식이고 항상 위에 고정된 형태이다.

**2) 위 카카오톡 사진처럼 상단바 부분을 self.view.bringSubviewToFront() 메소드를 사용해서 맨 앞단에 위치하게 해서 키보드가 나타날 때 이상하게 떠다녀 보이지 않도록 함**

<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/74a51bec-9781-4553-8f3a-d85f9bf49d4d"/>


- 저렇게 이상하게 떠돌아다니지는 않게는 됐고 입력창 위까지 위치시키는데까지는 성공했으나, 메시지 처음 내용까지 스크롤 시키는 것이 불가능했다.
- 더 정확히는 스크롤은 끝까지 가능하지만, tableview의 y값을 감소시켰기 때문에 상단바가 위의 값을 가리게 되어서 끝까지 스크롤되지 않는것처럼 보이는것이다.
- 여기서 고민하게 된것은 **"y값을 조정하지 않고도 키보드 + 입력창 크기에 맞춰서 마지막 데이터까지 보여주고, 위로 끝까지 스크롤할 수는 없을까?"** 하고 여러가지 레퍼런스를 찾아보던중 다음과 같은 레퍼런스를 찾게됐다.

https://seizze.github.io/2019/11/17/iOS%EC%97%90%EC%84%9C-%ED%82%A4%EB%B3%B4%EB%93%9C%EC%97%90-%EB%8F%99%EC%A0%81%EC%9D%B8-%EC%8A%A4%ED%81%AC%EB%A1%A4%EB%B7%B0-%EB%A7%8C%EB%93%A4%EA%B8%B0.html
https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard

- 이 레퍼런스들을 보니까 tableView의 contentInset을 계산해서 키보드가 나타날 때 / 사라질 때 나누어서 지정하는 것으로 보고, contentInset에 대해 알아보고 크기를 계산해보았다.

**3) UITableView의 ContentInset 적용 및 마지막 행으로 스크롤되도록 적용**

https://developer.apple.com/documentation/uikit/uiscrollview/1619406-contentinset

- 공식문서를 참고해보면 contentInset은 "컨텐트 뷰로부터 얼마나 안쪽으로 공백이 있는가"에 대한 내용이다.
<img width="500" alt="image (8)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/c90ad882-cda0-4e72-b4be-4d6b7e8223f7">

- 따라서 키보드가 나타날 때, 테이블뷰는 이미 입력창의 top에 제약이 걸려있으므로 keyboard height만 inset을 주고, 마지막 리스트로 스크롤 되게 했다. (scrollToRow -> 특정 row로 스크롤되게 하는 메소드)

<img width="500" alt="image (8)" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/0be14450-4baf-4e00-989b-5a8fec04118a">

```swift
@objcfunckeyboardWillShow(_ notification: Notification) { // keyboardFrameEndUserInfoKey : 키보드가 차지하는 frame의 CGRect값 반환
iflet keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue {
let keyboardRectangle = keyboardFrame.cgRectValue
let keyboardHeight = keyboardRectangle.height
            chatBackGround.frame.origin.y -= keyboardHeight
            messageContentsTableView.contentInset.bottom = keyboardHeight
            messageContentsTableView.scrollToRow(at: IndexPath(row: messageContentsTableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true) // 맨 마지막 내용으로 이동하도록
        }
    }

@objcfunckeyboardWillHide(_ notification: Notification) {
iflet keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue {
let keyboardRectangle = keyboardFrame.cgRectValue
let keyboardHeight = keyboardRectangle.height
            chatBackGround.frame.origin.y += keyboardHeight
            messageContentsTableView.contentInset.bottom = 0
            messageContentsTableView.scrollToRow(at: IndexPath(row: messageContentsTableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true) // 맨 마지막 내용으로 이동하도록
        }
    }
```
<img width="250" src="https://github.com/runner-be/RunnerBe-iOS/assets/37764504/7166e205-fa96-407d-91ed-df408b093690"/>
                                                                                                         
**frame.origin.y와 contentInset, scrollToRow에 대해 알 수 있었던 좋은 경험이었다.**

- **contentInset vs contentOffset**
- 차이점이 궁금해서 찾아보니 contentInset은 컨텐츠 안에 상하좌우 여백을 주는것이고 contentOffset은 어떤 x, y좌표로 스크롤하는지를 지정하는것같다.

  
</details>
