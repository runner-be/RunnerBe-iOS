//
//  BasicSignupService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

final class BasicSignupService: SignupService {
    var loginKeyChainService: LoginKeyChainService
    var signupKeyChainService: SignupKeyChainService
    let signupAPIService: SignupAPIService
    let emailCertificationService: EmailCertificationService
    let imageUploadService: ImageUploadService
    let randomNickNameGenerator: RandomNickNameGenerator

    init(
        loginKeyChainService: LoginKeyChainService,
        signupKeyChainService: SignupKeyChainService,
        signupAPIService: SignupAPIService,
        emailCertificationService: EmailCertificationService,
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

    func sendEmail(_: String) -> Observable<SignupWithEmailResult> {
        return .just(.emailDuplicated)
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
                    numOfRandom: 5,
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
