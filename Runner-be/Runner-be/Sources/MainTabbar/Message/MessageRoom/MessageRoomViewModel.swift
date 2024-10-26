//
//  MessageRoomViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

final class MessageRoomViewModel: BaseViewModel {
    var messages: [MessageContent] = []
    var images: [UIImage] = []
    var roomInfo: RoomInfo?

    init(messageAPIService: MessageAPIService = MessageAPIService(), roomId: Int) {
        super.init()

        routeInputs.needUpdate
            .flatMap { _ in messageAPIService.getMessageContents(roomId: roomId) }
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

        inputs.backward
            .map { true }
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.report
            .subscribe(onNext: { _ in
                self.routes.report.onNext(roomId)
            })
            .disposed(by: disposeBag)

        inputs.detailPost
            .compactMap { $0 }
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)

        inputs.sendMessage
            .throttle(.seconds(1), scheduler: MainScheduler.instance) // 누르고 1초 제한두기
            .flatMap {
                messageAPIService.postMessage(
                    roomId: roomId,
                    content: $0.0,
                    imageData: $0.1
                )
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .succeed:
                    self?.outputs.successSendMessage.onNext(true)
                    self?.routeInputs.needUpdate.onNext(true)
                    self?.images = []
                case .error:
                    // TODO: 실패원인 세분화
                    self?.toast.onNext("메시지 전송에 실패했습니다.")
                }
            }).disposed(by: disposeBag)

        inputs.tapPostImage
            .bind(to: routes.photoModal)
            .disposed(by: disposeBag)

        inputs.selectImage
            .filter { _ in
                if self.images.count < 3 {
                    return true
                } else {
                    AppContext.shared.makeToast("이미지는 3개 이상을 초과할 수 없습니다.(문구 임시)")
                    return false
                }
            }
            .bind { [weak self] image in
                guard let self = self else { return }
                self.images.append(image)
                self.outputs.selectedImages.onNext(self.images)
            }.disposed(by: disposeBag)

        inputs.deleteImage
            .filter { index in
                self.images.count > index
            }
            .bind { [weak self] index in
                guard let self = self else { return }
                self.images.remove(at: index)
                self.outputs.selectedImages.onNext(self.images)
            }.disposed(by: disposeBag)

        routeInputs.photoTypeSelected
            .compactMap { $0 }
            .bind(to: outputs.showPicker)
            .disposed(by: disposeBag)

        inputs.tapProfile
            .bind(to: routes.userPage)
            .disposed(by: disposeBag)
    }

    struct Input { // View에서 ViewModel로 전달되는 이벤트 정의
        var report = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var detailPost = PublishSubject<Int>()
        var sendMessage = PublishSubject<([String?], [Data?])>()
        var tapPostImage = PublishSubject<Void>()
        var selectImage = PublishSubject<UIImage>()
        var deleteImage = PublishSubject<Int>()
        var tapProfile = PublishSubject<Int>()
    }

    struct Output { // ViewModel에서 View로의 데이터 전달이 정의되어있는 구조체
        var roomInfo = PublishSubject<RoomInfo>()
        var messageContents = ReplaySubject<[MessageContent]>.create(bufferSize: 1)
        var successSendMessage = PublishSubject<Bool>()
        var showPicker = PublishSubject<EditProfileType>()
        var selectedImages = PublishSubject<[UIImage]>()
    }

    struct Route { // 화면 전환이 필요한 경우 해당 이벤트를 Coordinator에 전달하는 구조체
        var report = PublishSubject<Int>()
        var backward = PublishSubject<Bool>()
        var detailPost = PublishSubject<Int>()
        var photoModal = PublishSubject<Void>()
        var imageViewer = PublishSubject<UIImage>()
        var userPage = PublishSubject<Int>()
    }

    struct RouteInput { // 자식화면이 해제되면서 전달되어야하느 정보가 있을 경우, 전달되어야할 이벤트가 정의되어있는 구조체
        let report = PublishSubject<Int>()
        var backward = PublishSubject<(id: Int, needUpdate: Bool)>()
        var needUpdate = PublishSubject<Bool>()
        var photoTypeSelected = PublishSubject<EditProfileType?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
