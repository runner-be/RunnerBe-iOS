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
        var selectedStamp = ReplaySubject<(index: Int, stampType: StampType)>.create(bufferSize: 1)
        var selectedTemp = ReplaySubject<String>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var apply = PublishSubject<(stamp: StampType, temp: String)>()
    }

    struct RouteInputs {}

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var stamps: [LogStampConfig] = []
    var selectedStamp: StampType
    var selectedTemp: String? {
        didSet {
            if selectedTemp == nil || selectedTemp == "" {
                selectedTemp = "-"
            }
        }
    }

    // MARK: - Init

    init(selectedStamp: StampType, selectedTemp: String?) {
        self.selectedStamp = selectedStamp
        self.selectedTemp = selectedTemp

        super.init()
        let defaultStamps = [ // FIXME: - 하드코딩
            //            LogStampConfig(from: StampType(rawValue: "RUN001")),
//            LogStampConfig(from: StampType(rawValue: "RUN002")),
//            LogStampConfig(from: StampType(rawValue: "RUN003")),
//            LogStampConfig(from: StampType(rawValue: "RUN004")),
//            LogStampConfig(from: StampType(rawValue: "RUN005")),
//            LogStampConfig(from: StampType(rawValue: "RUN006")),
//            LogStampConfig(from: StampType(rawValue: "RUN007")),
//            LogStampConfig(from: StampType(rawValue: "RUN008")),
//            LogStampConfig(from: StampType(rawValue: "RUN009")),
//            LogStampConfig(from: StampType(rawValue: "RUN010")),
            LogStampConfig(from: StampType(rawValue: "WEA001")),
            LogStampConfig(from: StampType(rawValue: "WEA002")),
            LogStampConfig(from: StampType(rawValue: "WEA003")),
            LogStampConfig(from: StampType(rawValue: "WEA004")),
            LogStampConfig(from: StampType(rawValue: "WEA005")),
        ]

        stamps = defaultStamps // .filter { $0.stampType == 2 }

        outputs.logStamps.onNext(stamps)

        // 초기 `selectedStamp`의 인덱스 계산
        if let selectedIndex = stamps.firstIndex(where: { $0.stampType == selectedStamp }),
           let selectedTemp = self.selectedTemp
        {
            outputs.selectedStamp.onNext((index: selectedIndex, stampType: selectedStamp))
            outputs.selectedTemp.onNext(selectedTemp == "-" ? "" : selectedTemp)
        }

        inputs.tapStamp
            .compactMap { [weak self] itemIndex in
                guard let self = self,
                      let selectedStamp = stamps[itemIndex].stampType
                else { return nil }
                self.selectedStamp = selectedStamp

                return (index: itemIndex, stampType: selectedStamp)
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
