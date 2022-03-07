//
//  ApplicantListModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation
import RxSwift

final class ApplicantListModalViewModel: BaseViewModel {
    var applicants: [User]
    var changed = false

    init(postId: Int, applicants: [User], postAPIService: PostAPIService) {
        self.applicants = applicants
        super.init()

        inputs.backward
            .map { [weak self] in self?.changed ?? true }
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        Observable<[User]>.of(applicants)
            .map {
                $0.reduce(into: [UserConfig]()) {
                    $0.append(UserConfig(from: $1, owner: false))
                }
            }
            .subscribe(onNext: { [weak self] applicants in
                self?.outputs.participants.onNext(applicants)
            })
            .disposed(by: disposeBag)

        inputs.accept
            .flatMap {
                postAPIService.accept(postId: postId,
                                      applicantId: applicants[$0.idx].userID,
                                      accept: $0.accept)
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self
                else { return }

                let message: String
                if result.success {
                    message = result.accept ? "수락 완료" : "거절 완료"
                    self.applicants.removeAll(where: { $0.userID == result.id })
                    let configs = self.applicants.reduce(into: [UserConfig]()) {
                        $0.append(UserConfig(from: $1, owner: false))
                    }
                    self.outputs.participants.onNext(configs)
                    self.changed = true
                } else {
                    message = "수락 실패"
                }
                self.outputs.toast.onNext(message)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var accept = PublishSubject<(idx: Int, accept: Bool)>()
        var finishing = PublishSubject<Void>()
    }

    struct Output {
        var participants = ReplaySubject<[UserConfig]>.create(bufferSize: 1)
        var toast = PublishSubject<String>()
    }

    struct Route {
        var backward = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
