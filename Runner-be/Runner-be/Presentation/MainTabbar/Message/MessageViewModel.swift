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
    private let messageUseCase = MessageUseCase()

    override init() {
        super.init()

        uiBusinessLogic()
        requestDataToRepo()
    }

    // MARK: - INPUT, OUTPUT Modeling

    struct Input {
        var messageRoomId = PublishSubject<Int>()
        var insertedMessage = PublishSubject<String>()
    }

    struct Output {
        var messageRoomId = PublishSubject<Int>()
        var messageRoomList = ReplaySubject<[MessageRoom]>.create(bufferSize: 1)
    }

    struct Route {
        var goMessageRoom = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}

// MARK: - Repository와 소통

extension MessageViewModel {
    func requestDataToRepo() {
        routeInputs.needUpdate
            .flatMap { _ in
                self.messageUseCase.getMessageRoomList()
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
    }
}

// MARK: - UI 관련 비즈니스 로직

extension MessageViewModel {
    func uiBusinessLogic() {
        inputs.messageRoomId
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] roomId in
                self?.messageRoomId = roomId
                self?.routes.goMessageRoom.onNext(roomId)
            })
            .disposed(by: disposeBag)
    }
}
