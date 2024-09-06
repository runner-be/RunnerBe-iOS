//
//  ConfirmLogViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import RxSwift

final class ConfirmLogViewModel: BaseViewModel {
    // MARK: - Properties

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    var logForm: LogForm

    // MARK: - Init

    init(
        logForm: LogForm,
        logAPIService: LogAPIService = BasicLogAPIService()
    ) {
        self.logForm = logForm
        super.init()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        let formattedDate = dateFormatter.string(from: logForm.runningDate)
        outputs.logDate.onNext(formattedDate)

        logAPIService.fetchLog(year: "2024", month: "8")
            .bind { detailLog in
                print("sejfilsefj detailLog: \(detailLog)")
            }.disposed(by: disposeBag)

        let testReceivedStamps = [
            ReceivedStampConfig(from: ReceivedStamp(
                userName: "지현",
                userProfileURL: "",
                stampStatus: .RUN001
            )),
            ReceivedStampConfig(from: ReceivedStamp(
                userName: "러닝이",
                userProfileURL: "",
                stampStatus: .RUN004
            )),
            ReceivedStampConfig(from: ReceivedStamp(
                userName: "스피듀광",
                userProfileURL: "",
                stampStatus: .RUN010
            )),
        ]

        outputs.receivedStamps.onNext(testReceivedStamps)
    }

    // MARK: - Methods

    struct Input {}

    struct Output {
        var receivedStamps = ReplaySubject<[ReceivedStampConfig]>.create(bufferSize: 1)
        var logDate = ReplaySubject<String>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Bool>()
    }

    struct RouteInput {}
}
