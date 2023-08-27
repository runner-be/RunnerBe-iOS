//
//  MessageReportViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import Foundation
import RxSwift

final class MessageReportViewModel: BaseViewModel {
    var messages: [MessageContent] = []
    var roomInfo: RoomInfo?
    var reportIntString = ""
    var roomId = 0

    var reportMessageList: [Int] = []
    var reportMessageIndexString = ""
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
    }

    struct Output { // ViewModel에서 View로의 데이터 전달이 정의되어있는 구조체
        var detailPost = PublishSubject<Int>()
        var messageContents = ReplaySubject<[MessageContent]>.create(bufferSize: 1)
        var roomInfo = PublishSubject<RoomInfo>()
    }

    struct Route { // 화면 전환이 필요한 경우 해당 이벤트를 Coordinator에 전달하는 구조체
        var report = PublishSubject<Void>()
        var backward = PublishSubject<Bool>()
        var detailPost = PublishSubject<Int>()
    }

    struct RouteInput { // 자식화면이 해제되면서 전달되어야하느 정보가 있을 경우, 전달되어야할 이벤트가 정의되어있는 구조체
        let report = PublishSubject<Bool>()
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

extension MessageReportViewModel {
    func requestDataToRepo() {
        messageUseCase.getMessageContents(roomId: roomId)
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

        routeInputs.report
            .flatMap { _ in self.messageUseCase.reportMessages(reportMessageIndexString: self.reportIntString) }
            .map { [weak self] result -> Bool? in
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
            .subscribe(onNext: { result in
                if let result = result {
                    if result {
                        self.toast.onNext("신고가 접수되었습니다.")
                    } else {
                        self.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI 관련 비즈니스 로직

extension MessageReportViewModel {
    func uiBusinessLogic() {
        inputs.detailPost
            .compactMap { $0 }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)

        inputs.backward
            .map { true }
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.report
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.reportIntString = self.reportMessageList.map { String($0) }.joined(separator: ",")
                self.routes.report.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
