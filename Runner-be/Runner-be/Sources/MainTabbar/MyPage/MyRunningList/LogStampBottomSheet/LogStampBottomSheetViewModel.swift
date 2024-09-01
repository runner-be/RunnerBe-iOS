//
//  LogStampBottomSheetViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import Foundation
import RxSwift

final class LogStampBottomSheetViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var tapStamp = PublishSubject<Int>()
        var register = PublishSubject<Void>()
    }

    struct Output {
        var logStamps = ReplaySubject<[LogStampConfig]>.create(bufferSize: 1)
        var selectedStamp = ReplaySubject<(index: Int, logStamp: LogStamp2)>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var applay = PublishSubject<LogStamp2>()
    }

    struct RouteInputs {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var logStamps: [LogStampConfig] = []
    var selectedStamp: LogStamp2

    // MARK: - Init

    init(selectedStamp: LogStamp2) {
        self.selectedStamp = selectedStamp
        super.init()
        // FIXME: - 하드코딩
        logStamps = [
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN001", stampName: "체크")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN002", stampName: "성취")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN003", stampName: "사교")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN004", stampName: "지속")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN005", stampName: "흥미")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN006", stampName: "성장")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN007", stampName: "독기")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN008", stampName: "감성")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN009", stampName: "쾌락")),
            LogStampConfig(from: LogStamp2(stampType: 1, stampCode: "RUN010", stampName: "질주")),
        ]

        outputs.logStamps.onNext(logStamps)

        // 초기 `selectedStamp`의 인덱스 계산
        if let selectedIndex = logStamps.firstIndex(where: { $0.stampCode == selectedStamp.stampCode }) {
            outputs.selectedStamp.onNext((index: selectedIndex, logStamp: selectedStamp))
        }

        inputs.tapStamp
            .compactMap { [weak self] itemIndex in
                guard let self = self else { return nil }
                let selectedStamp = LogStamp2(
                    stampType: logStamps[itemIndex].stampType,
                    stampCode: logStamps[itemIndex].stampCode,
                    stampName: logStamps[itemIndex].stampName
                )
                self.selectedStamp = selectedStamp

                return (index: itemIndex, logStamp: selectedStamp)
            }
            .bind(to: outputs.selectedStamp)
            .disposed(by: disposeBag)

        inputs.register
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return self.selectedStamp
            }
            .bind(to: routes.applay)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
