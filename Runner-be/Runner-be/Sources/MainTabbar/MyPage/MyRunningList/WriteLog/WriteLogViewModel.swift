//
//  WriteLogViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import RxSwift

final class WriteLogViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var showLogStampBottomSheet = PublishSubject<Void>()
    }

    struct Output {
        var selectedLogStamp = PublishSubject<LogStamp2>()
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var logStampBottomSheet = PublishSubject<LogStamp2>()
    }

    struct RouteInput {
        var selectedLogStamp = PublishSubject<LogStamp2>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    var selectedLogStamp: LogStamp2?

    // MARK: - Init

    init(postId _: Int) {
        super.init()

        inputs.showLogStampBottomSheet
            .map { [weak self] _ in
                guard let selectedLogStamp = self?.selectedLogStamp
                else { // FIXME: - 하드코딩
                    return LogStamp2(
                        stampType: 1,
                        stampCode: "RUN001",
                        stampName: "Check!"
                    )
                }
                return selectedLogStamp
            }
            .bind(to: routes.logStampBottomSheet)
            .disposed(by: disposeBag)

        routeInputs.selectedLogStamp
            .map { [weak self] selectedLogStamp in
                self?.selectedLogStamp = selectedLogStamp
                return selectedLogStamp
            }
            .bind(to: outputs.selectedLogStamp)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
