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
    var writingPostData: WritingPostData
    private let postUseCase = PostUseCase()

    struct ViewInputData {
        let gender: Int
        let ageMin: Int
        let ageMax: Int
        let numPerson: Int
        let textContent: String
    }

    init(writingPostData: WritingPostData) {
        self.writingPostData = writingPostData
        super.init()

        outputs.writingPostData.onNext(writingPostData)

        inputs.posting
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] inputData in
                if inputData == nil {
                    self?.toast.onNext("데이터 처리에 실패하였습니다.")
                }
            })
            .compactMap { $0 }
            .filter { $0.ageMin >= 20 && $0.ageMin <= $0.ageMax && $0.ageMax <= 65 && $0.numPerson >= 2 }
            .map { [weak self] data -> PostingForm? in
                let runningTag = RunningTag(name: writingPostData.tag)
                let gender = Gender(idx: data.gender)
                let gatheringTime = DateUtil.shared.formattedString(for: Date(timeIntervalSince1970: writingPostData.date), format: .yyyyMMddHHmmss)
                guard runningTag != .error,
                      let runningTime = DateUtil.shared.changeFormat(writingPostData.time, from: .korHmm, to: .HHmm) // "\($0.time)시간 \($0.minute)분"
                else {
                    self?.toast.onNext("날짜를 불러오는데 실패했습니다.")
                    return nil
                }
                Log.d(tag: .info, "gathering Time : \(gatheringTime), runningTime: \(runningTime)")

                return PostingForm(
                    title: writingPostData.title,
                    gatheringTime: gatheringTime,
                    runningTime: runningTime,
                    gatherLongitude: Float(writingPostData.location.longitude),
                    gatherLatitude: Float(writingPostData.location.latitude),
                    locationInfo: writingPostData.placeInfo,
                    runningTag: runningTag,
                    ageMin: data.ageMin,
                    ageMax: data.ageMax,
                    peopleNum: data.numPerson,
                    contents: data.textContent,
                    runnerGender: gender
                )
            }
            .compactMap { $0 }
            .flatMap { self.postUseCase.posting(form: $0) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(data):
                    switch data {
                    case .succeed:
                        self?.routes.apply.onNext(())
                    case let .genderDenied(message):
                        self?.toast.onNext(message)
                    case .fail:
                        self?.toast.onNext("다시 시도해주세요!")
                    case .needLogin:
                        self?.toast.onNext("로그인이 필요합니다")
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
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
        var writingPostData = ReplaySubject<WritingPostData>.create(bufferSize: 1)
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
