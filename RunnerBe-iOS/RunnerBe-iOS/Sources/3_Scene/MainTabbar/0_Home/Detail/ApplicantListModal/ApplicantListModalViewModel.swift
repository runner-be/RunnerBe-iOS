//
//  ApplicantListModalViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation
import RxSwift

final class ApplicantListModalViewModel: BaseViewModel {
    init(postId: Int, applicants: [User], postAPIService: PostAPIService) {
        super.init()

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)

        Observable<[User]>.of(applicants)
            .map {
                $0.reduce(into: [PostDetailUserConfig]()) {
                    $0.append(PostDetailUserConfig(from: $1, owner: false))
                }
            }
            .bind(to: outputs.participants)
            .disposed(by: disposeBag)

        inputs.accept
            .flatMap { postAPIService.accept(postId: postId, applicantId: applicants[$0].userID, accept: true) }
            .subscribe(onNext: { [weak self] success in
                let message: String
                if success {
                    message = "수락 완료"
                } else {
                    message = "수락 실패"
                }
                self?.outputs.toast.onNext(message)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var accept = PublishSubject<Int>()
        var refuse = PublishSubject<Int>()
        var finishing = PublishSubject<Void>()
    }

    struct Output {
        var participants = ReplaySubject<[PostDetailUserConfig]>.create(bufferSize: 1)
        var toast = PublishSubject<String>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
