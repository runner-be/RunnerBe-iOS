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
        var togetherRunnerList = ReplaySubject<[TogetherRunner]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var logStampBottomSheet = PublishSubject<(stamp: LogStamp2, title: String)>()
        var confirmLog = PublishSubject<LogForm>()
    }

    struct RouteInputs {
        var selectedLogStamp = PublishSubject<LogStamp2>()
        var needUpdate = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInputs()

    var runnerList: [TogetherRunner] = []
    var selectedIndex: Int?

    // MARK: - Init

    override init() {
        super.init()

        runnerList = [
            TogetherRunner(
                usetProfileURL: "",
                userNickname: "김조장",
                stamp: nil
            ),
            TogetherRunner(
                usetProfileURL: "",
                userNickname: "쥬쥬",
                stamp: nil
            ),
            TogetherRunner(
                usetProfileURL: "",
                userNickname: "맹고",
                stamp: nil
            ),
            TogetherRunner(
                usetProfileURL: "",
                userNickname: "정",
                stamp: nil
            ),
            TogetherRunner(
                usetProfileURL: "",
                userNickname: "스탬프 안주고 싶은사람",
                stamp: nil
            ),
            TogetherRunner(
                usetProfileURL: "",
                userNickname: "수정",
                stamp: nil
            ),
        ]

        outputs.togetherRunnerList.onNext(runnerList)

        routeInputs.needUpdate
            .filter { $0 }
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return runnerList
            }
            .bind(to: outputs.togetherRunnerList)
            .disposed(by: disposeBag)

        inputs.tapRunner
            .compactMap { [weak self] itemIndex in
                self?.selectedIndex = itemIndex

                guard let self = self,
                      let selectedStamp = self.runnerList[itemIndex].stamp
                else { // FIXME: 하드코딩
                    return (stamp: LogStamp2(
                        stampType: 1,
                        stampCode: "RUN001",
                        stampName: "Check!"
                    ), title: "{닉네임}에게 \n 러닝 스탬프를 찍어봐요!")
                }

                return (
                    stamp: selectedStamp,
                    title: "{닉네임}에게 \n 러닝 스탬프를 찍어봐요!"
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

                return LogForm(
                    runningDate: Date(),
                    logId: 0,
                    stampCode: nil,
                    contents: nil,
                    imageUrl: nil,
                    weatherDegree: nil,
                    weatherIcon: nil,
                    isOpened: 1
                )
            }
            .bind(to: routes.confirmLog)
            .disposed(by: disposeBag)

        routeInputs.selectedLogStamp
            .compactMap { [weak self] stamp in
                guard let self = self,
                      let selectedIndex = selectedIndex
                else { return nil }
                runnerList[selectedIndex].stamp = stamp
                return self.runnerList
            }.bind(to: outputs.togetherRunnerList)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
