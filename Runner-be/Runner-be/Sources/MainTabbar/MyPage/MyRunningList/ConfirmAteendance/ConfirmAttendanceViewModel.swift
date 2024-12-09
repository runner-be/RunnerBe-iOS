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

    struct Output {
        var runnerInfoList = ReplaySubject<[RunnerInfo]>.create(bufferSize: 1)
    }

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
    var runnerInfoList: [RunnerInfo] = []

    // MARK: - Init

    init(
        postId: Int,
        postAPIService: PostAPIService = BasicPostAPIService()
    ) {
        print("seiflsnilf postID: \(postId)")
        self.postId = postId
        super.init()

        postAPIService.attendanceList(postId: postId)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(data):
                    self?.runnerInfoList = data
                    self?.outputs.runnerInfoList.onNext(data)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                }

            }).disposed(by: disposeBag)
    }

    // MARK: - Methods
}
