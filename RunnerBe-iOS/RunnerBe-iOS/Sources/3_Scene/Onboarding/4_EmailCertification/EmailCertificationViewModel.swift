//
//  EmailCertificationViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

final class EmailCertificationViewModel: BaseViewModel {
    private let signupService: SignupService

    init(signupService: SignupService) {
        self.signupService = signupService
        super.init()

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapNoEmail
            .subscribe(routes.toIDCardCertification)
            .disposed(by: disposeBag)

        inputs.emailText
            .do(onNext: { [weak self] _ in
                self?.outputs.emailDuplicated.onNext(false)
            })
            .map { $0?.count ?? 0 }
            .map { $0 != 0 }
            .bind(to: outputs.enableNext)
            .disposed(by: disposeBag)

        inputs.tapCertificate
            .do(onNext: { [weak self] _ in
                self?.outputs.enableCertificate.onNext(false)
            })
            .map { [weak self] address in
                self?.signupService.sendEmail(address)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .emailDuplicated:
                    self?.outputs.emailDuplicated.onNext(true)
                case .sendEmailCompleted:
                    self?.outputs.emailSended.onNext(())
                case .sendEmailFailed:
                    // TODO: 이메일 전송 실패 시 처리
                    break
                }
                self?.outputs.enableCertificate.onNext(true)
            })
            .disposed(by: disposeBag)

        routeInputs.emailCertifated
            .map { [weak self] in self?.signupService.emailCertificated(email: $0) }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.routes.signupComplete.onNext(())
                case .fail:
                    // TODO: 오류메시지
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapNoEmail = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
        var tapCertificate = PublishSubject<String>()

        var emailText = PublishSubject<String?>()
    }

    struct Output {
        var enableNext = PublishSubject<Bool>()
        var enableCertificate = PublishSubject<Bool>()
        var emailDuplicated = PublishSubject<Bool>()
        var emailSended = PublishSubject<Void>()
    }

    struct Route {
        var signupComplete = PublishSubject<Void>()
        var toIDCardCertification = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
    }

    struct RouteInput {
        var emailCertifated = PublishSubject<String>()
    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    // MARK: Private

    private var disposeBag = DisposeBag()
}
