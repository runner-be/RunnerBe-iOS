//
//  MessageViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

final class MessageRoomViewModel: BaseViewModel {
    var messages: [MessageContent] = []
    var roomInfo: RoomInfo?
    var roomId = 0
    private let messageUseCase = MessageUseCase()

    init(roomId: Int) {
        super.init()

        self.roomId = roomId

        uiBusinessLogic()
        requestDataToRepo()
    }

    // MARK: - INPUT, OUTPUT Modeling

    struct Input { // View에서 ViewModel로 전달되는 이벤트 정의
        var report = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var detailPost = PublishSubject<Int>()
        var sendMessage = PublishSubject<String>()
    }

    struct Output { // ViewModel에서 View로의 데이터 전달이 정의되어있는 구조체
        var roomInfo = PublishSubject<RoomInfo>()
        var messageContents = ReplaySubject<[MessageContent]>.create(bufferSize: 1)
        var successSendMessage = PublishSubject<Bool>()
    }

    struct Route { // 화면 전환이 필요한 경우 해당 이벤트를 Coordinator에 전달하는 구조체
        var report = PublishSubject<Int>()
        var backward = PublishSubject<Bool>()
        var detailPost = PublishSubject<Int>()
    }

    struct RouteInput { // 자식화면이 해제되면서 전달되어야하느 정보가 있을 경우, 전달되어야할 이벤트가 정의되어있는 구조체
        let report = PublishSubject<Int>()
        var backward = PublishSubject<(id: Int, needUpdate: Bool)>()
        var needUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}

// MARK: - Repository와 소통

extension MessageRoomViewModel {
    func requestDataToRepo() {
        routeInputs.needUpdate
            .flatMap { _ in self.messageUseCase.getMessageContents(roomId: self.roomId) }
            .map { [weak self] result -> GetMessageRoomInfoResult? in
                switch result {
                case let .response(result: data):
                    return data
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return nil
                }
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.messages.removeAll()

                if let result = result {
                    self.messages = result.messageList ?? []

                    guard let roomInfos = result.roomInfo else {
                        self.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                        return
                    }
                    self.roomInfo = roomInfos[0]

                    if !self.messages.isEmpty {
                        self.outputs.messageContents.onNext(self.messages)
                    } else {
                        self.outputs.messageContents.onNext([])
                    }

                    self.outputs.roomInfo.onNext(self.roomInfo!)
                }

            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI 관련 비즈니스 로직

extension MessageRoomViewModel {
    func uiBusinessLogic() {
        inputs.backward
            .map { true }
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.report
            .subscribe(onNext: { _ in
                self.routes.report.onNext(self.roomId)
            })
            .disposed(by: disposeBag)

        inputs.detailPost
            .compactMap { $0 }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)

        inputs.sendMessage
            .throttle(.seconds(1), scheduler: MainScheduler.instance) // 누르고 1초 제한두기
            .flatMap { self.messageUseCase.postMessage(roomId: self.roomId, content: $0) }
            .map { result in
                switch result {
                case let .response(result: data):
                    return data
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    }
                    return false
                }
            }
            .subscribe(onNext: { isPosted in
                if isPosted {
                    self.outputs.successSendMessage.onNext(true)
                    self.routeInputs.needUpdate.onNext(true)
                }
            })
            .disposed(by: disposeBag)
    }
}
