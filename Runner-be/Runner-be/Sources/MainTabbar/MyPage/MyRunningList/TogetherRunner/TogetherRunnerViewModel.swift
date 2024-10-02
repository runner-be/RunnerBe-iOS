//
//  TogetherRunnerViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 9/3/24.
//

import Foundation
import RxSwift

final class TogetherRunnerViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var tapRunner = PublishSubject<Int>()
        var tapShowLogButton = PublishSubject<Int>()
    }

    struct Output {
        var togetherRunnerList = ReplaySubject<[LogPartners]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var logStampBottomSheet = PublishSubject<(stamp: StampType, title: String)>()
        var confirmLog = PublishSubject<Int>()
    }

    struct RouteInputs {
        var selectedLogStamp = PublishSubject<StampType>()
        var needUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var partnerList: [LogPartners] = []
    var selectedIndex: Int?

    // MARK: - Init

    init(
        gatheringId: Int,
        logAPIService: LogAPIService = BasicLogAPIService()
    ) {
        super.init()

        logAPIService.partners(gatheringId: gatheringId)
            .compactMap { [weak self] result -> [LogPartners]? in
                switch result {
                case let .response(data):
                    if let data = data {
                        return data
                    }
                    self?.toast.onNext("함께한 러너 프로필 조회에 실패했습니다.")
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                    return nil
                }
                return nil
            }
            .subscribe(onNext: { [weak self] logPartners in
                self?.partnerList = logPartners
                self?.outputs.togetherRunnerList.onNext(logPartners)

            })
            .disposed(by: disposeBag)

        routeInputs.needUpdate
            .filter { $0 }
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return partnerList
            }
            .bind(to: outputs.togetherRunnerList)
            .disposed(by: disposeBag)

        inputs.tapRunner
            .compactMap { [weak self] itemIndex in
                self?.selectedIndex = itemIndex
                guard let self = self,
                      let stampCode = self.partnerList[itemIndex].stampCode,
                      let selectedLogStamp = StampType(rawValue: stampCode)
                else {
                    return nil
                }

                return (
                    stamp: selectedLogStamp,
                    title: "\(self.partnerList[itemIndex].nickname)에게 \n 러닝 스탬프를 찍어봐요!"
                )
            }
            .bind(to: routes.logStampBottomSheet)
            .disposed(by: disposeBag)

        inputs.tapShowLogButton
            .compactMap { [weak self] _ in
                guard let self = self
                else {
                    return nil
                }

                // FIXME: 함께한 러너 API 완료되면 수정
                return 0
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        routeInputs.selectedLogStamp
            .compactMap { [weak self] stamp in
                guard let self = self,
                      let selectedIndex = selectedIndex
                else {
                    return nil
                }
                partnerList[selectedIndex].stampCode = stamp.rawValue
                return self.partnerList
            }.bind(to: outputs.togetherRunnerList)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
