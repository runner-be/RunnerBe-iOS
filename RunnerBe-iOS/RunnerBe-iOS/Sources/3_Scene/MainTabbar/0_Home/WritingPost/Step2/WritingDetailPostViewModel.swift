//
//  WritingDetailPostViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import CoreLocation
import Foundation
import RxSwift

final class WritingDetailPostViewModel: BaseViewModel {
    typealias ViewInputData = (gender: Int, ageMin: Int, ageMax: Int, numPerson: Int, textContent: String)

    private var mainPageAPIService: PostAPIService

    init(mainPostData: PostMainData, postAPIService: PostAPIService) {
        mainPageAPIService = postAPIService
        super.init()

        outputs.mainPostData.onNext(mainPostData)

        inputs.posting
            .do(onNext: { [weak self] inputData in
                if inputData == nil {
                    self?.outputs.toast.onNext("데이터 처리에 실패하였습니다.")
                }
            })
            .compactMap { $0 }
            .filter { $0.ageMin >= 20 && $0.ageMin <= $0.ageMax && $0.ageMax <= 65 && $0.numPerson >= 2 }
            .map { [weak self] data -> PostingForm? in
                let runningTag = RunningTag(name: mainPostData.tag)
                let gender = Gender(idx: data.gender)
                let curYearGathringDate = DateUtil.shared.getCurrent(format: .yyyy) + " " + mainPostData.date
                guard runningTag != .error,
                      let gatheringTime = DateUtil.shared.changeFormat(curYearGathringDate, from: .yyyyMdEahmm, to: .yyyyMMddHHmmss), // "\($0.date) \($0.ampm) \($0.time):\($0.minute)"
                      let runningTime = DateUtil.shared.changeFormat(mainPostData.time, from: .korHmm, to: .HHmm) // "\($0.time)시간 \($0.minute)분"
                else {
                    self?.outputs.toast.onNext("날짜를 불러오는데 실패했습니다.")
                    return nil
                }

                print("gathering Time : \(gatheringTime), runningTime: \(runningTime)")

                return PostingForm(
                    title: mainPostData.title,
                    gatheringTime: gatheringTime,
                    runningTime: runningTime,
                    gatherLongitude: Float(mainPostData.location.longitude),
                    gatherLatitude: Float(mainPostData.location.latitude),
                    locationInfo: mainPostData.placeInfo,
                    runningTag: runningTag,
                    ageMin: data.ageMin,
                    ageMax: data.ageMax,
                    peopleNum: data.numPerson,
                    contents: data.textContent,
                    runnerGender: gender
                )
            }
            .compactMap { $0 }
            .flatMap { postAPIService.posting(form: $0) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .succeed:
                    self?.routes.apply.onNext(())
                case .fail:
                    self?.outputs.toast.onNext("다시 시도해주세요!")
                case .needLogin:
                    self?.outputs.toast.onNext("로그인이 필요합니다")
                }
            })
            .disposed(by: disposeBag)

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var posting = PublishSubject<ViewInputData?>()
    }

    struct Output {
        var mainPostData = ReplaySubject<PostMainData>.create(bufferSize: 1)
        var toast = PublishSubject<String>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var apply = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
