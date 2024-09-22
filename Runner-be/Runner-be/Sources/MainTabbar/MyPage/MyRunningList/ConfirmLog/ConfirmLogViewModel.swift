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

        logAPIService.detail(logId: logForm.logId ?? 0)
            .compactMap { [weak self] result -> LogDetail? in
                switch result {
                case let .response(data):
                    if let data = data {
                        return data
                    }
                    self?.toast.onNext("로그 상세 조회에 실패했습니다.")
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return nil
                }
                return nil
            }
            .subscribe(onNext: { [weak self] logDetail in
                self?.outputs.logDetail.onNext(logDetail)
                let test: [GotStampConfig] = logDetail.gotStamp.compactMap { GotStampConfig(from: $0) }
                self?.outputs.gotStamps.onNext(test)
            }).disposed(by: disposeBag)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        let formattedDate = dateFormatter.string(from: logForm.runningDate)
        outputs.logDate.onNext(formattedDate)
    }

    // MARK: - Methods

    struct Input {}

    struct Output {
        var gotStamps = ReplaySubject<[GotStampConfig]>.create(bufferSize: 1)
        var logDate = ReplaySubject<String>.create(bufferSize: 1)
        var logDetail = ReplaySubject<LogDetail>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var modal = PublishSubject<Void>()
    }

    struct RouteInput {}
}
