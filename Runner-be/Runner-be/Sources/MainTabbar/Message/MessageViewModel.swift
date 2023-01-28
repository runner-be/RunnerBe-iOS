//
//  MessageViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

final class MessageViewModel: BaseViewModel {
    var messages: [MessageListItem] = []
    var roomId = 0

    init(messageAPIService: MessageAPIService = MessageAPIService()) {
        super.init()

        routeInputs.needUpdate // API로부터 북마크 목록 뿌리는 부분
            .flatMap { _ in
                messageAPIService.getMessageList() // flatMap : Observable을 벗겨냄
            }
            .map { [weak self] result -> [MessageListItem]? in
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
                    self.messages = result

                    if !self.messages.isEmpty {
                        self.outputs.messageLists.onNext(self.messages)
                    } else {
                        self.outputs.messageLists.onNext([])
                    }
                }

            })
            .disposed(by: disposeBag)

        inputs.messageChat
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] roomId in
                self?.roomId = roomId
                self?.routes.messageChat.onNext(roomId)
            })
            .disposed(by: disposeBag)
        
//        inputs.insertedMessage
//            .compactMap { $0 }
//            .flatMap { messageAPIService.postMessage(roomId: self.roomId, content: $0)}
//            .subscribe(onNext: { [weak self] result in
//                switch result {
//                case let .response(result: true):
//                    routeInputs.needUpdate.onNext(true) // 다시 업데이트
//                }
//            })
    }

    struct Input { // View에서 ViewModel로 전달되는 이벤트 정의
        var messageChat = PublishSubject<Int>()
        var insertedMessage = PublishSubject<String>()
    }

    struct Output { // ViewModel에서 View로의 데이터 전달이 정의되어있는 구조체
        var messageChat = PublishSubject<Int>()
        var messageLists = ReplaySubject<[MessageListItem]>.create(bufferSize: 1)
    }

    struct Route { // 화면 전환이 필요한 경우 해당 이벤트를 Coordinator에 전달하는 구조체
        var messageChat = PublishSubject<Int>()
    }

    struct RouteInput { // 자식화면이 해제되면서 전달되어야하느 정보가 있을 경우, 전달되어야할 이벤트가 정의되어있는 구조체
        var needUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
