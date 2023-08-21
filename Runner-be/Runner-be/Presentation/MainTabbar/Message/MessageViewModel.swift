//
//  MessageViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

final class MessageViewModel: BaseViewModel {
    var messageRoomList: [MessageRoom] = []
    var messageRoomId = 0

    init(messageAPIService: MessageAPIService = MessageAPIService()) {
        super.init()

        routeInputs.needUpdate
            .flatMap { _ in
                messageAPIService.getMessageRoomList()
            }
            .map { [weak self] result -> [MessageRoom]? in
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
                self.messageRoomList.removeAll()

                if let result = result {
                    self.messageRoomList = result

                    if !self.messageRoomList.isEmpty {
                        self.outputs.messageRoomList.onNext(self.messageRoomList)
                    } else {
                        self.outputs.messageRoomList.onNext([])
                    }
                }

            })
            .disposed(by: disposeBag)

        inputs.messageRoomId
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] roomId in
                self?.messageRoomId = roomId
                self?.routes.goMessageRoom.onNext(roomId)
            })
            .disposed(by: disposeBag)
    }

    struct Input { // View에서 ViewModel로 전달되는 이벤트 정의
        var messageRoomId = PublishSubject<Int>()
        var insertedMessage = PublishSubject<String>()
    }

    struct Output { // ViewModel에서 View로의 데이터 전달이 정의되어있는 구조체
        var messageRoomId = PublishSubject<Int>()
        var messageRoomList = ReplaySubject<[MessageRoom]>.create(bufferSize: 1)
    }

    struct Route { // 화면 전환이 필요한 경우 해당 이벤트를 Coordinator에 전달하는 구조체
        var goMessageRoom = PublishSubject<Int>()
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
