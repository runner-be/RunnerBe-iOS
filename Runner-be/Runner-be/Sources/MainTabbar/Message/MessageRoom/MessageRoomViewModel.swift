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
    var postInfo: RoomInfo?

    init(messageAPIService: MessageAPIService = MessageAPIService(), roomId: Int) {
        super.init()

        routeInputs.needUpdate
            .flatMap { _ in messageAPIService.getMessages(roomId: roomId) }
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
                    self.postInfo = result.roomInfo![0]

                    if !self.messages.isEmpty {
                        self.outputs.messageContents.onNext(self.messages)
                    } else {
                        self.outputs.messageContents.onNext([])
                    }

                    self.outputs.roomInfo.onNext(self.postInfo!)
                }

            })
            .disposed(by: disposeBag)

        inputs.backward
            .map { [weak self] in true }
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.report
            .compactMap { $0 }
            .bind(to: routes.report)
            .disposed(by: disposeBag)

        inputs.detailPost
            .compactMap { $0 }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)
    }

    struct Input { // View에서 ViewModel로 전달되는 이벤트 정의
        var report = PublishSubject<Int>()
        var backward = PublishSubject<Void>()
        var detailPost = PublishSubject<Int>()
    }

    struct Output { // ViewModel에서 View로의 데이터 전달이 정의되어있는 구조체
        var roomInfo = PublishSubject<RoomInfo>()
        var messageContents = ReplaySubject<[MessageContent]>.create(bufferSize: 1)
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
        var detailClosed = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
