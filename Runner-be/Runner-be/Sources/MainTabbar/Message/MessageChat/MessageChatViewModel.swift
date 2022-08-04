//
//  MessageViewModel.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

final class MessageChatViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.report
            .subscribe(routes.report)
            .disposed(by: disposeBag)

        routeInputs.report
            .subscribe(onNext: { [weak self] report in
                if report {
                    self?.outputs.toast.onNext("신고가 접수되었습니다.")
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input { // View에서 ViewModel로 전달되는 이벤트 정의
        var report = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    struct Output { // ViewModel에서 View로의 데이터 전달이 정의되어있는 구조체
        var toast = PublishSubject<String>()
    }

    struct Route { // 화면 전환이 필요한 경우 해당 이벤트를 Coordinator에 전달하는 구조체
        var report = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
    }

    struct RouteInput { // 자식화면이 해제되면서 전달되어야하느 정보가 있을 경우, 전달되어야할 이벤트가 정의되어있는 구조체
        let report = PublishSubject<Bool>()
        var backward = PublishSubject<(id: Int, needUpdate: Bool)>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
