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
        var selectedStamp = ReplaySubject<(index: Int, stampType: StampType)>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var applay = PublishSubject<StampType>()
    }

    struct RouteInputs {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var logStamps: [LogStampConfig] = []
    var selectedStamp: StampType

    // MARK: - Init

    init(
        selectedStamp: StampType,
        gatheringId: Int?
    ) {
        self.selectedStamp = selectedStamp
        let isEnabled = (gatheringId != nil)
        super.init()
        // FIXME: - 하드코딩
        logStamps = [
            LogStampConfig(from: StampType(rawValue: "RUN001"), isEnabled: true),
            LogStampConfig(from: StampType(rawValue: "RUN002"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN003"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN004"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN005"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN006"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN007"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN008"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN009"), isEnabled: isEnabled),
            LogStampConfig(from: StampType(rawValue: "RUN010"), isEnabled: isEnabled),
        ]

        outputs.logStamps.onNext(logStamps)

        // 초기 `selectedStamp`의 인덱스 계산
        if let selectedIndex = logStamps.firstIndex(where: { $0.stampType == selectedStamp }) {
            outputs.selectedStamp.onNext((index: selectedIndex, stampType: selectedStamp))
        }

        inputs.tapStamp
            .compactMap { [weak self] itemIndex in
                guard let self = self,
                      let selectedStamp = logStamps[itemIndex].stampType
                else { return nil }
                self.selectedStamp = selectedStamp

                return (index: itemIndex, stampType: selectedStamp)
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
