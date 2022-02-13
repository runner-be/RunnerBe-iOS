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
    case needsUUID
}

enum SignupWithIdCardResult {
    case imageUploaded
    case imageUploadFail
    case needUUID
}

protocol SignupService {
    func sendEmail(_ email: String) -> Observable<SignupWithEmailResult>
    func certificateIdCardImage(_ data: Data) -> Observable<SignupWithIdCardResult>
}
