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
        var selectedStamp = ReplaySubject<(
            index: Int,
            stampType: StampType,
            stampSubTitle: String,
            stampSubTitleColor: UIColor
        )>.create(bufferSize: 1)
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
        let isPersonalLog = (gatheringId == nil)
        super.init()
        // FIXME: - 하드코딩
        logStamps = [
            LogStampConfig(from: StampType(rawValue: "RUN001"), isEnabled: true),
            LogStampConfig(from: StampType(rawValue: "RUN002"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN003"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN004"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN005"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN006"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN007"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN008"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN009"), isEnabled: !isPersonalLog),
            LogStampConfig(from: StampType(rawValue: "RUN010"), isEnabled: !isPersonalLog),
        ]

        outputs.logStamps.onNext(logStamps)

        // 초기 `selectedStamp`의 인덱스 계산
        if let selectedIndex = logStamps.firstIndex(where: { $0.stampType == selectedStamp }) {
            outputs.selectedStamp.onNext((
                index: selectedIndex,
                stampType: selectedStamp,
                stampSubTitle: selectedStamp.subTitle,
                stampSubTitleColor: .darkG35
            ))
        }

        inputs.tapStamp
            .compactMap { [weak self] itemIndex in
                guard let self = self,
                      let selectedStamp = logStamps[itemIndex].stampType
                else { return nil }
                self.selectedStamp = selectedStamp
                // TODO: 리팩토링
                let disabled = isPersonalLog && selectedStamp != .RUN001
                let stampSubTitle = disabled ? "{\(selectedStamp.title)} 스탬프는 크루 활동시 얻을 수 있어요!" : selectedStamp.subTitle
                let stampSubTitleColor = disabled ? UIColor.primarydark : UIColor.darkG35
                return (
                    index: itemIndex,
                    stampType: selectedStamp,
                    stampSubTitle: stampSubTitle,
                    stampSubTitleColor: stampSubTitleColor
                )
            }
            .bind(to: outputs.selectedStamp)
            .disposed(by: disposeBag)

        inputs.register
            .filter { _ in
                if !isPersonalLog {
                    return true
                } else {
                    return self.selectedStamp == .RUN001
                }
            }
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return self.selectedStamp
            }
            .bind(to: routes.applay)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
