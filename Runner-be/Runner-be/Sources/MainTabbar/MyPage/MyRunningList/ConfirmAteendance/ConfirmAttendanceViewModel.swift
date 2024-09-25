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
        var runnerList = ReplaySubject<[RunnerList]>.create(bufferSize: 1)
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
    var runnerList: [RunnerList] = []

    // MARK: - Init

    init(
        postId: Int,
        postAPIService: PostAPIService = BasicPostAPIService()
    ) {
        print("seiflsnilf postID: \(postId)")
        self.postId = postId
        super.init()

        postAPIService.getRunnerList()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(data):
                    if let data = data,
                       let runnerList = data[postId].runnerList
                    {
                        self?.runnerList = runnerList
                        self?.outputs.runnerList.onNext(runnerList)
                    }
                    self?.toast.onNext("출석 조회에 실패했습니다.")

                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                }
            }).disposed(by: disposeBag)
    }

    // MARK: - Methods
}
