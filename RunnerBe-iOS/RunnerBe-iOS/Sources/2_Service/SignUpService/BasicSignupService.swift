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
    let dynamicLinkService: DynamicLinkService
    let emailCertificationService: MailingCertificationService
    let imageUploadService: ImageUploadService
    let randomNickNameGenerator: RandomNickNameGenerator

    var disposeBag = DisposeBag()

    init(
        loginKeyChainService: LoginKeyChainService,
        signupKeyChainService: SignupKeyChainService,
        signupAPIService: SignupAPIService,
        dynamicLinkService: DynamicLinkService,
        emailCertificationService: MailingCertificationService,
        imageUploadService: ImageUploadService,
        randomNickNameGenerator: RandomNickNameGenerator
    ) {
        self.loginKeyChainService = loginKeyChainService
        self.signupKeyChainService = signupKeyChainService
        self.signupAPIService = signupAPIService
        self.dynamicLinkService = dynamicLinkService
        self.emailCertificationService = emailCertificationService
        self.imageUploadService = imageUploadService
        self.randomNickNameGenerator = randomNickNameGenerator
    }

    func sendEmail(_ email: String) -> Observable<SignupWithEmailResult> {
        let emailCheckOK = ReplaySubject<Void>.create(bufferSize: 1)
        let dynamicLinkResult = ReplaySubject<URL>.create(bufferSize: 1)
        let sendEmailResult = ReplaySubject<SignupWithEmailResult>.create(bufferSize: 1)

        signupAPIService.checkEmailOK(email)
            .debug()
            .take(1)
            .subscribe(onNext: {
                if $0 {
                    emailCheckOK.onNext(())
                } else {
                    sendEmailResult.onNext(.emailDuplicated)
                }
            })
            .disposed(by: disposeBag)

        emailCheckOK
            .debug()
            .map { [weak self] in self?.dynamicLinkService.generateLink() }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: {
                guard let url = $0
                else {
                    sendEmailResult.onNext(.sendEmailFailed)
                    return
                }
                dynamicLinkResult.onNext(url)
            })
            .disposed(by: disposeBag)

        dynamicLinkResult
            .debug()
            .map { [weak self] url in
                self?.emailCertificationService.send(address: email, dynamicLink: url.absoluteString)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { emailResult in
                switch emailResult {
                case .success:
                    sendEmailResult.onNext(.sendEmailCompleted)
                case .fail:
                    sendEmailResult.onNext(.sendEmailFailed)
                }
            })
            .disposed(by: disposeBag)

        return sendEmailResult
            .do(onNext: { [weak self] _ in
                self?.disposeBag = DisposeBag()
            })
    }

    func certificateIdCardImage(_ data: Data) -> Observable<SignupWithIdCardResult> {
        let uuid = signupKeyChainService.uuid
        if uuid.isEmpty {
            return .just(.needUUID)
        }
        let path = "IdCardCertification/\(uuid).png"

        let imageUploaded = ReplaySubject<String>.create(bufferSize: 1)
        let keyChainWithOutNickName = ReplaySubject<Void>.create(bufferSize: 1)
        let signupFormReady = ReplaySubject<SignupForm>.create(bufferSize: 1)
        let functionResult = ReplaySubject<SignupWithIdCardResult>.create(bufferSize: 1)

        imageUploadService.uploadImage(data: data, path: path)
            .debug()
            .subscribe(onNext: { url in
                guard let url = url
                else {
                    functionResult.onNext(.imageUploadFail)
                    return
                }
                imageUploaded.onNext(url)
            })
            .disposed(by: disposeBag)

        imageUploaded
            .debug()
            .subscribe(onNext: { [weak self] idCardUrl in
                guard let self = self
                else {
                    functionResult.onNext(.imageUploadFail)
                    return
                }
                self.signupKeyChainService.idCardUrl = idCardUrl
                self.signupKeyChainService.nickName = self.randomNickNameGenerator.generate(
                    numOfRandom: 4,
                    prefix: "Runner",
                    suffix: ""
                )
                self.signupKeyChainService.officeMail = nil

                let form = self.signupKeyChainService.signupForm
                signupFormReady.onNext(form)
            })
            .disposed(by: disposeBag)

        imageUploaded
            .debug()
            .subscribe(onNext: { [weak self] idCardUrl in
                guard var keyChain = self?.signupKeyChainService
                else {
                    // TODO: unowned?
                    functionResult.onNext(.imageUploadFail)
                    return
                }

                keyChain.idCardUrl = idCardUrl
                keyChain.officeMail = nil
                keyChainWithOutNickName.onNext(())
            })
            .disposed(by: disposeBag)

        keyChainWithOutNickName
            .debug()
            .subscribe(onNext: { [weak self] in
                guard var keyChain = self?.signupKeyChainService,
                      let nickNameGenerator = self?.randomNickNameGenerator
                else {
                    // TODO: unowned?
                    functionResult.onNext(.imageUploadFail)
                    return
                }

                keyChain.nickName = nickNameGenerator.generate(
                    numOfRandom: 4,
                    prefix: "Runner",
                    suffix: ""
                )

                signupFormReady.onNext(keyChain.signupForm)
            })
            .disposed(by: disposeBag)

        signupFormReady
            .debug()
            .map { [weak self] form in
                self?.signupAPIService.signup(with: form)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { result in
                guard let result = result
                else {
                    functionResult.onNext(.imageUploadFail)
                    return
                }

                switch result {
                case .succeed:
                    functionResult.onNext(.imageUploaded)
                case let .error(code):
                    if code == 2009 { // 닉네임 중복 오류
                        keyChainWithOutNickName.onNext(())
                    } else {
                        functionResult.onNext(.imageUploadFail)
                    }

                    #if DEBUG
                        if code == 3001 {
                            print("[BasicSignupService][Certificate ID card] 중복된 uuid: \"\(uuid)\"")
                        }
                    #endif
                }
            })
            .disposed(by: disposeBag)

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposeBag = DisposeBag()
            })
    }
}
