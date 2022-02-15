//
//  SignupService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

enum SignupWithEmailResult {
    case emailDuplicated
    case sendEmailCompleted
    case sendEmailFailed
}

enum EmailCertificatedResult {
    case success
    case fail
}

enum SignupWithIdCardResult {
    case imageUploaded
    case imageUploadFail
    case needUUID
}

protocol SignupService {
    func sendEmail(_ email: String) -> Observable<SignupWithEmailResult>
    func emailCertificated(email: String) -> Observable<EmailCertificatedResult>
    func certificateIdCardImage(_ data: Data) -> Observable<SignupWithIdCardResult>
}
