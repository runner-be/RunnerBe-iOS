//
//  ConfirmAttendanceViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import Foundation
import RxSwift

final class ConfirmAttendanceViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {}

    struct Output {}

    struct Route {
        var backward = PublishSubject<Void>()
    }

    struct RouteInputs {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    let postId: Int
    var runnerList: [RunnerList] = []

    // MARK: - Init

    init(postId: Int) {
        self.postId = postId
        super.init()
        runnerList = [
            RunnerList(userID: 0, nickName: "A", gender: "", age: nil, diligence: nil, job: nil, profileImageURL: nil, whetherCheck: nil, attendance: nil, whetherPostUser: nil, pace: nil),
            RunnerList(userID: 1, nickName: "B", gender: "", age: nil, diligence: nil, job: nil, profileImageURL: nil, whetherCheck: nil, attendance: nil, whetherPostUser: nil, pace: nil),
            RunnerList(userID: 2, nickName: "C", gender: "", age: nil, diligence: nil, job: nil, profileImageURL: nil, whetherCheck: nil, attendance: nil, whetherPostUser: nil, pace: nil),
        ]
    }

    // MARK: - Methods
}
