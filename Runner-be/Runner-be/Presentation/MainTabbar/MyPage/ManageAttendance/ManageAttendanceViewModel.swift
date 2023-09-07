//
//  ManageAttendanceViewModel.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import Foundation
import RxSwift

final class ManageAttendanceViewModel: BaseViewModel {
    private let postUseCase = PostUseCase()

    // 유저 관련
    var posts = [MyPosting]()
    var runnerList: [RunnerList] = []
    var attendTimeOver = "N"
    var postID = -1
    var myRunningIdx = -1

    var userIdList: [Int] = [] // 유저 id 리스트
    var whetherAttendList: [String] = [] // 위 각각 유저 별로 참여 여부를 저장하는 리스트

    init(myRunningIdx: Int) {
        self.myRunningIdx = myRunningIdx
        super.init()

        requestDataToUseCase()
        uiBusinessLogic()
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var showExpiredModal = PublishSubject<Void>()
        var goToMyPage = PublishSubject<Void>()
        var patchAttendance = PublishSubject<Void>()
    }

    struct Output {
        var goToMyPage = PublishSubject<Bool>()
        var runnerList = PublishSubject<Void>()
        var info = PublishSubject<MyPosting>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var showExpiredModal = PublishSubject<Void>()
        var goToMyPage = PublishSubject<Void>()
    }

    struct RouteInputs {
        var showExpiredModal = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()
}

extension ManageAttendanceViewModel {
    func requestDataToUseCase() {
        postUseCase.getRunnerList()
            .subscribe(onNext: { result in

                switch result {
                case let .response(result: result):
                    let myRunningIdx = self.myRunningIdx

                    self.outputs.info.onNext(result![myRunningIdx])
                    self.attendTimeOver = result![myRunningIdx].attendTimeOver!
                    self.postID = result![myRunningIdx].postID!
                    self.runnerList = result![myRunningIdx].runnerList!

                    self.userIdList = self.runnerList.map { $0.userID! }
                    self.whetherAttendList = Array(repeating: "-", count: self.runnerList.count)

                    self.outputs.runnerList.onNext(())
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.patchAttendance
            .flatMap { self.postUseCase.mangageAttendance(postId: self.postID, request: PatchAttendanceRequest(userIdList: self.userIdList.map { String($0) }.joined(separator: ","), whetherAttendList: self.whetherAttendList.joined(separator: ",")))
            }
            .subscribe(onNext: { result in

                switch result {
                case .response(result: _):
                    self.toast.onNext("출석이 제출되었습니다.")
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

    func uiBusinessLogic() {
        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        inputs.showExpiredModal
            .bind(to: routes.showExpiredModal)
            .disposed(by: disposeBag)

        inputs.goToMyPage
            .bind(to: routes.goToMyPage)
            .disposed(by: disposeBag)
    }
}
