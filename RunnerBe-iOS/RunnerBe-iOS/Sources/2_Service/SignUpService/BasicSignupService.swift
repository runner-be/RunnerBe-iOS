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
        signupKeyChainService.officeMail = email

        let emailCheckOK = ReplaySubject<Void>.create(bufferSize: 1)
        let uuidReady = ReplaySubject<String>.create(bufferSize: 1)
        let dynamicLinkReady = ReplaySubject<URL>.create(bufferSize: 1)
        let functionResult = ReplaySubject<SignupWithEmailResult>.create(bufferSize: 1)

        signupAPIService.checkEmailOK(email)
            .debug()
            .take(1)
            .subscribe(onNext: {
                if $0 {
                    emailCheckOK.onNext(())
                } else {
                    functionResult.onNext(.emailDuplicated)
                }
            })
            .disposed(by: disposeBag)

        emailCheckOK.subscribe(onNext: { [weak self] in
            guard let signupKeyChain = self?.signupKeyChainService,
                  !signupKeyChain.uuid.isEmpty
            else {
                functionResult.onNext(.sendEmailFailed)
                return
            }
            uuidReady.onNext(signupKeyChain.uuid)
        })
        .disposed(by: disposeBag)

        uuidReady
            .debug()
            .map { [weak self] uuid in
                self?.dynamicLinkService.generateLink(
                    resultPath: "EmailCertification",
                    parameters: ["id": uuid.sha256, "email": email]
                )
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: {
                guard let url = $0
                else {
                    functionResult.onNext(.sendEmailFailed)
                    return
                }
                dynamicLinkReady.onNext(url)
            })
            .disposed(by: disposeBag)

        dynamicLinkReady
            .debug()
            .map { [weak self] url in
                self?.emailCertificationService.send(address: email, dynamicLink: url.absoluteString)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { emailResult in
                switch emailResult {
                case .success:
                    functionResult.onNext(.sendEmailCompleted)
                case .fail:
                    functionResult.onNext(.sendEmailFailed)
                }
            })
            .disposed(by: disposeBag)

        return functionResult
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

    func emailCertificated(email: String) -> Observable<EmailCertificatedResult> {
        let functionResult = ReplaySubject<EmailCertificatedResult>.create(bufferSize: 1)
        let formReadyWithoutNickName = ReplaySubject<Void>.create(bufferSize: 1)
        let formReady = ReplaySubject<SignupForm>.create(bufferSize: 1)

        signupKeyChainService.officeMail = email
        signupKeyChainService.idCardUrl = nil
        formReadyWithoutNickName.onNext(())

        formReadyWithoutNickName
            .subscribe(onNext: { [weak self] in
                guard var keyChain = self?.signupKeyChainService,
                      let nickNameGenerator = self?.randomNickNameGenerator
                else {
                    functionResult.onNext(.fail)
                    return
                }
                keyChain.nickName = nickNameGenerator.generate(
                    numOfRandom: 4,
                    prefix: "Runner",
                    suffix: ""
                )
                formReady.onNext(keyChain.signupForm)
            })
            .disposed(by: disposeBag)

        formReady
            .map { [weak self] form in
                self?.signupAPIService.signup(with: form)
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] apiResult in
                guard let self = self,
                      let result = apiResult
                else {
                    functionResult.onNext(.fail)
                    return
                }

                switch result {
                case let .succeed(jwt):
                    self.loginKeyChainService.token = LoginToken(jwt: jwt)
                    functionResult.onNext(.success)
                case let .error(code):
                    if code == 2009 {
                        formReadyWithoutNickName.onNext(())
                    } else {
                        functionResult.onNext(.fail)
                    }
                }
            })
            .disposed(by: disposeBag)

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposeBag = DisposeBag()
            })
    }
}
