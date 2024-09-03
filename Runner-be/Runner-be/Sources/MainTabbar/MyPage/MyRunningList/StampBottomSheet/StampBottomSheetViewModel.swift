//
//  StampBottomSheetViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 9/2/24.
//

import Foundation
import RxSwift

final class StampBottomSheetViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var tapStamp = PublishSubject<Int>()
        var temperature = PublishSubject<String?>()
        var register = PublishSubject<Void>()
    }

    struct Output {
        var logStamps = ReplaySubject<[LogStampConfig]>.create(bufferSize: 1)
        var selectedStamp = ReplaySubject<(index: Int, logStamp: LogStamp2)>.create(bufferSize: 1)
        var selectedTemp = ReplaySubject<String>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var apply = PublishSubject<(stamp: LogStamp2, temp: String)>()
    }

    struct RouteInputs {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var stamps: [LogStampConfig] = []
    var selectedStamp: LogStamp2
    var selectedTemp: String? {
        didSet {
            if selectedTemp == nil || selectedTemp == "" {
                selectedTemp = "-"
            }
        }
    }

    // MARK: - Init

    init(selectedStamp: LogStamp2, selectedTemp: String?) {
        self.selectedStamp = selectedStamp
        self.selectedTemp = selectedTemp

        super.init()
        let defaultStamps = [ // FIXME: - 하드코딩
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
            LogStampConfig(from: LogStamp2(stampType: 2, stampCode: "WEA001", stampName: "맑음")),
            LogStampConfig(from: LogStamp2(stampType: 2, stampCode: "WEA002", stampName: "흐림")),
            LogStampConfig(from: LogStamp2(stampType: 2, stampCode: "WEA003", stampName: "야간")),
            LogStampConfig(from: LogStamp2(stampType: 2, stampCode: "WEA004", stampName: "비")),
            LogStampConfig(from: LogStamp2(stampType: 2, stampCode: "WEA005", stampName: "눈")),
        ]

        stamps = defaultStamps.filter { $0.stampType == 2 }

        outputs.logStamps.onNext(stamps)

        // 초기 `selectedStamp`의 인덱스 계산
        if let selectedIndex = stamps.firstIndex(where: { $0.stampCode == selectedStamp.stampCode }),
           let selectedTemp = self.selectedTemp
        {
            outputs.selectedStamp.onNext((index: selectedIndex, logStamp: selectedStamp))
            outputs.selectedTemp.onNext(selectedTemp == "-" ? "" : selectedTemp)
        }

        inputs.tapStamp
            .compactMap { [weak self] itemIndex in
                guard let self = self else { return nil }
                let selectedStamp = LogStamp2(
                    stampType: stamps[itemIndex].stampType,
                    stampCode: stamps[itemIndex].stampCode,
                    stampName: stamps[itemIndex].stampName
                )
                self.selectedStamp = selectedStamp

                return (index: itemIndex, logStamp: selectedStamp)
            }
            .bind(to: outputs.selectedStamp)
            .disposed(by: disposeBag)

        inputs.temperature
            .bind { [weak self] temp in
                self?.selectedTemp = temp
            }.disposed(by: disposeBag)

        inputs.register
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return (self.selectedStamp, self.selectedTemp ?? "-")
            }
            .bind(to: routes.apply)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
