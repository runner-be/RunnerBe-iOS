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

    var logDetail: LogDetail?

    // MARK: - Init

    init(
        logId: Int,
        logAPIService: LogAPIService = BasicLogAPIService()
    ) {
        super.init()

        routeInputs.needUpdate
            .filter { $0 }
            .flatMap { _ in
                logAPIService.detail(logId: logId)
            }
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

                let gotStamps: [GotStampConfig] = logDetail.gotStamp.compactMap { GotStampConfig(from: $0) }
                self?.outputs.gotStamps.onNext(gotStamps)

                self?.logDetail = logDetail

            }).disposed(by: disposeBag)

        // 로그 수정
        routeInputs.editLog
            .compactMap { [weak self] _ in
                guard let logDetail = self?.logDetail else { return nil }
                return LogForm(
                    runningDate: logDetail.runningDate ?? Date(),
                    logId: logId,
                    stampCode: logDetail.detailRunningLog?.stampCode,
                    contents: logDetail.contents,
                    imageUrl: logDetail.imageURL,
                    imageData: nil,
                    weatherDegree: logDetail.detailRunningLog?.weatherDegree,
                    weatherIcon: logDetail.weatherStamp?.rawValue,
                    isOpened: logDetail.isOpened ? 1 : 2
                )
            }
            .bind(to: routes.writeLog)
            .disposed(by: disposeBag)

        // 로그 삭제
        routeInputs.deleteLog
            .flatMap { // TODO: 0으로 logId를 사용하게되면, 진짜 에러원인을 찾기 어려움
                logAPIService.delete(logId: logId)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .response:
                    self?.toast.onNext("게시글이 삭제되었습니다.")
                    self?.routes.backward.onNext(true)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생해 게시글 삭제되지 않았습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)

        inputs.tapGotStamp
            .compactMap { [weak self] index in
                guard let self = self else { return nil }
                return self.logDetail?.gotStamp[index].logId
            }
            .bind(to: routes.newConfirmLog)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    struct Input {
        var tapGotStamp = PublishSubject<Int>()
    }

    struct Output {
        var gotStamps = ReplaySubject<[GotStampConfig]>.create(bufferSize: 1)
        var logDate = ReplaySubject<String>.create(bufferSize: 1)
        var logDetail = ReplaySubject<LogDetail>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var modal = PublishSubject<Void>()
        var writeLog = PublishSubject<LogForm>()
        var newConfirmLog = PublishSubject<Int>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var editLog = PublishSubject<Void>()
        var deleteLog = PublishSubject<Void>()
    }
}
