//
//  BasicSignupService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxRelay
import RxSwift

final class BasicSignupService: SignupService {
    var loginKeyChainService: LoginKeyChainService
    var signupKeyChainService: SignupKeyChainService
    let signupAPIService: SignupAPIService
    let emailCertificationService: MailingCertificationService
    let imageUploadService: ImageUploadService
    let randomNickNameGenerator: RandomNickNameGenerator

    var disposeBag = DisposeBag()

    init(
        loginKeyChainService: LoginKeyChainService,
        signupKeyChainService: SignupKeyChainService,
        signupAPIService: SignupAPIService,
        emailCertificationService: MailingCertificationService,
        imageUploadService: ImageUploadService,
        randomNickNameGenerator: RandomNickNameGenerator
    ) {
        self.loginKeyChainService = loginKeyChainService
        self.signupKeyChainService = signupKeyChainService
        self.signupAPIService = signupAPIService
        self.emailCertificationService = emailCertificationService
        self.imageUploadService = imageUploadService
        self.randomNickNameGenerator = randomNickNameGenerator
    }

    func sendEmail(_ email: String) -> Observable<SignupWithEmailResult> {
        let sendResult = ReplaySubject<SignupWithEmailResult>.create(bufferSize: 1)

        signupAPIService.checkEmailOK(email)
            .take(1)
            .filter {
                if !$0 {
                    #if DEBUG
                        print("[BasicSignupService][sendEmail] checkEmailOk false, return .emailDuplicated")
                    #endif
                    sendResult.onNext(.emailDuplicated)
                }
                return $0
            }
            .map { [weak self] _ in // email is not duplicated
                self?.emailCertificationService.send(address: email, dynamicLink: "링크!")
            }
            .compactMap { result -> Observable<MailingCertificationResult>? in
                #if DEBUG
                    print("[BasicSignupService][sendEmail] result of send is nil, return .sendEmailFail")
                #endif
                if result == nil { sendResult.onNext(.sendEmailFailed) }
                return result
            }
            .flatMap { $0 }
            .subscribe(onNext: {
                switch $0 {
                case .success:
                    #if DEBUG
                        print("[BasicSignupService][sendEmail] send success, return .sendEmailCompleted")
                    #endif
                    sendResult.onNext(.sendEmailCompleted)
                case .fail:
                    #if DEBUG
                        print("[BasicSignupService][sendEmail] send success, return .sendEmailFailed")
                    #endif
                    sendResult.onNext(.sendEmailFailed)
                }
            })
            .disposed(by: disposeBag)

        return sendResult
            .debug()
    }

    func certificateIdCardImage(_ data: Data) -> Observable<SignupWithIdCardResult> {
        let uuid = signupKeyChainService.uuid
        if uuid.isEmpty {
            return .just(.needUUID)
        }
        let path = "IdCardCertification/\(uuid).png"

        return imageUploadService.uploadImage(data: data, path: path)
            .asObservable()
            .map { [weak self] url -> Observable<SignupAPIResult?> in
                guard let self = self,
                      let url = url
                else { return .just(nil) }
                self.signupKeyChainService.idCardUrl = url
                self.signupKeyChainService.nickName = self.randomNickNameGenerator.generate(
                    numOfRandom: 4,
                    prefix: "Runner",
                    suffix: ""
                )
                var signupForm = self.signupKeyChainService.signupForm
                signupForm.officeEmail = nil
                return self.signupAPIService.signup(with: signupForm)
            }
            .flatMap { $0 }
            .map { [weak self] result -> Observable<SignupAPIResult?> in
                guard let self = self,
                      let result = result
                else { return .just(nil) }
                switch result {
                case .succeed:
                    return .just(result)
                case let .error(code):
                    if code == 2009 { // 닉네임 중복 오류
                        return self.retrySignupWhenNickNameDuplicated()
                    }
                }
                return .just(nil)
            }
            .flatMap { $0 }
            .map { [weak self] result -> SignupWithIdCardResult in
                guard let result = result else { return .imageUploadFail }
                switch result {
                case let .succeed(token):
                    #if DEBUG
                        print("[BasicSignupService][certificateIdCardImage] \(#line) success! token : \(token) return .imageUploaded")
                    #endif
                    self?.loginKeyChainService.token = LoginToken(token: token)
                    return .imageUploaded
                default:
                    #if DEBUG
                        print("[BasicSignupService][certificateIdCardImage] \(#line) fail .imageUploadFail")
                    #endif
                    return .imageUploadFail
                }
            }
    }

    private func retrySignupWhenNickNameDuplicated() -> Observable<SignupAPIResult?> {
        #if DEBUG
            print("[BasicSignupService][NickNameErr] Retry")
        #endif
        signupKeyChainService.nickName = randomNickNameGenerator.generate(
            numOfRandom: 4,
            prefix: "Runner",
            suffix: ""
        )
        let signupForm = signupKeyChainService.signupForm
        return signupAPIService.signup(with: signupForm)
            .map { [weak self] result -> Observable<SignupAPIResult?> in
                guard let self = self,
                      let result = result
                else { return Observable<SignupAPIResult?>.just(nil) }

                switch result {
                case .succeed:
                    return .just(result)
                case let .error(code):
                    if code == 2009 { // 닉네임 중복오류
                        return self.retrySignupWhenNickNameDuplicated()
                    }
                }
                return .just(result)
            }
            .flatMap { $0 }
    }
}
