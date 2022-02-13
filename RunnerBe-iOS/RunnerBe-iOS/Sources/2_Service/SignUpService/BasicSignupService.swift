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

    init(
        loginKeyChainService: LoginKeyChainService,
        signupKeyChainService: SignupKeyChainService,
        signupAPIService: SignupAPIService,
        emailCertificationService: EmailCertificationService,
        imageUploadService: ImageUploadService
    ) {
        self.loginKeyChainService = loginKeyChainService
        self.signupKeyChainService = signupKeyChainService
        self.signupAPIService = signupAPIService
        self.emailCertificationService = emailCertificationService
        self.imageUploadService = imageUploadService
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
            .map { [weak self] url -> Observable<SignupResultData?> in
                guard let self = self,
                      let url = url
                else { return .just(nil) }
                self.signupKeyChainService.idCardUrl = url

                var signupForm = self.signupKeyChainService.signupForm
                signupForm.officeEmail = nil
                return self.signupAPIService.signup(with: signupForm)
            }
            .flatMap { $0 }
            .map { [weak self] result -> SignupWithIdCardResult in
                guard let result = result else { return .imageUploadFail }

                self?.loginKeyChainService.token = LoginToken(token: result.token)
                return .imageUploaded
            }
    }
}
