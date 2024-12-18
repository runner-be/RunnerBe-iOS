//
//  ManageAttendanceViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import Foundation
import RxSwift

final class ManageAttendanceViewModel: BaseViewModel {
    var posts = [MyPosting]()
    var runnerList: [RunnerInfo] = []
    var attendTimeOver = false
    var postID = -1

    init(
        myRunningId: Int,
        postAPIService: PostAPIService = BasicPostAPIService()
    ) {
        postID = myRunningId
        super.init()

        routeInputs.needUpdate
            .flatMap { _ in postAPIService.manageAttendacne(postId: myRunningId) }
            .subscribe(onNext: { result in
                switch result {
                case let .response(result: result):
                    self.outputs.info.onNext(result)
                    self.attendTimeOver = result.attendTimeOver
                    self.runnerList = result.attendanceList
                    self.outputs.runnerList.onNext(result.attendanceList)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.showExpiredModal
            .bind(to: routes.showExpiredModal)
            .disposed(by: disposeBag)

        inputs.goToMyPage
            .bind(to: routes.goToMyPage)
            .disposed(by: disposeBag)

        inputs.patchAttendance
            .flatMap { postAPIService.mangageAttendance(
                postId: self.postID,
                request: PatchAttendanceRequest(
                    userIdList: $0.userIdList,
                    whetherAttendList: $0.whetherAttendList
                )
            ) }
            .subscribe(onNext: { result in
                switch result {
                case .response(result: _):
                    self.toast.onNext("제출 완료")
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var showExpiredModal = PublishSubject<Void>()
        var goToMyPage = PublishSubject<Void>()
        var patchAttendance = PublishSubject<(userIdList: String, whetherAttendList: String)>()
    }

    struct Output {
        var goToMyPage = PublishSubject<Bool>()
        var runnerList = ReplaySubject<[RunnerInfo]>.create(bufferSize: 1)
        var info = PublishSubject<ManageAttendance>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var showExpiredModal = PublishSubject<Void>()
        var goToMyPage = PublishSubject<Void>()
    }

    struct RouteInputs {
        var needUpdate = PublishSubject<Bool>()
        var showExpiredModal = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()
}
