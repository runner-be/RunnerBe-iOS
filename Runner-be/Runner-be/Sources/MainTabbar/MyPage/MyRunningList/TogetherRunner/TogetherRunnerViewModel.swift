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
        logId: Int,
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
                    return (
                        stamp: StampType(rawValue: "RUN001")!,
                        title: "에게 \n 러닝 스탬프를 찍어봐요!"
                    )
                }

                return (
                    stamp: selectedLogStamp,
                    title: "\(self.partnerList[itemIndex].nickname)에게 \n 러닝 스탬프를 찍어봐요!"
                )
            }
            .bind(to: routes.logStampBottomSheet)
            .disposed(by: disposeBag)

        inputs.tapShowLogButton
            .compactMap { [weak self] itemIndex in
                guard let self = self
                else {
                    return nil
                }
                print("snei0fjs90ejfes: \(self.partnerList[itemIndex].logId)")
                return self.partnerList[itemIndex].logId
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        routeInputs.selectedLogStamp
            .compactMap { [weak self] stampType in
                guard let self = self,
                      let selectedIndex = selectedIndex
                else {
                    return nil
                }
                partnerList[selectedIndex].stampCode = stampType.rawValue
                return self.partnerList
            }.bind(to: outputs.togetherRunnerList)
            .disposed(by: disposeBag)

        routeInputs.selectedLogStamp
            .flatMap { [weak self] stampType -> Observable<APIResult<LogResult>> in
                guard let self = self,
                      let selectedIndex = self.selectedIndex
                else {
                    // TODO: 에러 원인 더 명확하게
                    return Observable.empty()
                }

                let targetId = self.partnerList[selectedIndex].userId
                if let currentStampCode = self.partnerList[selectedIndex].stampCode {
                    self.partnerList[selectedIndex].stampCode = stampType.rawValue
                    return logAPIService.editPartnerStamp(
                        logId: logId,
                        targetId: targetId,
                        stampCode: stampType.rawValue
                    )
                } else {
                    self.partnerList[selectedIndex].stampCode = stampType.rawValue
                    return logAPIService.postPartnerStamp(
                        logId: logId,
                        targetId: targetId,
                        stampCode: stampType.rawValue
                    )
                }
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .response:
                    toast.onNext("스탬프를 주었습니다.")
                    outputs.togetherRunnerList.onNext(partnerList)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        toast.onNext(alertMessage)
                    } else {
                        toast.onNext("오류가 발생해 게시글 삭제되지 않았습니다.")
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
