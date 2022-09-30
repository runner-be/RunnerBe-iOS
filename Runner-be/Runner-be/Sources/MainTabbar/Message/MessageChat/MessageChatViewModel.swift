//
//  MessageViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

final class MessageChatViewModel: BaseViewModel {
    init(messageId _: Int) {
        super.init()

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
        var detailPost = PublishSubject<Int>()
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
