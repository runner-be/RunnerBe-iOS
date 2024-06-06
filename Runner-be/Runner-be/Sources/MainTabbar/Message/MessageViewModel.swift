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

        routeInputs.photoTypeSelected
            .compactMap { $0 }
            .bind(to: outputs.showPicker)
            .disposed(by: disposeBag)

        inputs.messageRoomId
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] roomId in
                self?.messageRoomId = roomId
                self?.routes.goMessageRoom.onNext(roomId)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var messageRoomId = PublishSubject<Int>()
        var insertedMessage = PublishSubject<String>()
    }

    struct Output {
        var messageRoomId = PublishSubject<Int>()
        var messageRoomList = ReplaySubject<[MessageRoom]>.create(bufferSize: 1)
        var showPicker = PublishSubject<EditProfileType>()
    }

    struct Route {
        var goMessageRoom = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var photoTypeSelected = PublishSubject<EditProfileType?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
