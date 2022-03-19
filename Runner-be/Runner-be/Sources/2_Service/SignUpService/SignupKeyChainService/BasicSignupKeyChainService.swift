//
//  BasicSignupKeyChainService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import SwiftKeychainWrapper

final class BasicSignupKeyChainService: SignupKeyChainService {
    let keychainWrapper: KeychainWrapper
    var userKeyChainService: UserKeychainService

    init(keychainWrapper: KeychainWrapper = .standard, userKeyChainService: UserKeychainService) {
        self.keychainWrapper = keychainWrapper
        self.userKeyChainService = userKeyChainService
    }

    var signupForm: SignupForm {
        get {
            SignupForm(
                uuid: userKeyChainService.uuid,
                nickName: userKeyChainService.nickName,
                birthday: userKeyChainService.birthDay,
                gender: userKeyChainService.gender,
                job: userKeyChainService.job,
                officeEmail: officeMail,
                idCardImageUrl: idCardUrl
            )
        }
        set {
            userKeyChainService.uuid = newValue.uuid
            userKeyChainService.nickName = newValue.nickName
            userKeyChainService.birthDay = newValue.birthday
            userKeyChainService.gender = newValue.gender
            userKeyChainService.job = newValue.job
            officeMail = newValue.officeEmail
            idCardUrl = newValue.idCardImageUrl
        }
    }

    var uuid: String {
        get { userKeyChainService.uuid }
        set { userKeyChainService.uuid }
    }

    var nickName: String {
        get { userKeyChainService.nickName }
        set { userKeyChainService.nickName = newValue }
    }

    var birthDay: Int {
        get { userKeyChainService.birthDay }
        set { userKeyChainService.birthDay = newValue }
    }

    var job: Job {
        get { userKeyChainService.job }
        set { userKeyChainService.job = newValue }
    }

    var gender: Gender {
        get { userKeyChainService.gender }

        set { userKeyChainService.gender = newValue }
    }

    var officeMail: String? {
        get {
            let mail: String? = keychainWrapper[.SignupInfo.officeEmail]
            #if DEBUG
                print("[BasicSignupKeyChainService][officeMail] get\n\t \"\(mail)\"")
            #endif
            return mail
        }
        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][officeMail] set\n\t= \"\(newValue ?? "")\"")
            #endif
            keychainWrapper.remove(forKey: .SignupInfo.officeEmail)
            if let mail = newValue {
                keychainWrapper.set(mail, forKey: KeychainWrapper.Key.SignupInfo.officeEmail.rawValue)
            }
        }
    }

    var idCardUrl: String? {
        get {
            let url: String? = keychainWrapper[.SignupInfo.idCardImageUrl]
            #if DEBUG
                print("[BasicSignupKeyChainService][idCardUrl] get\n\t = \"\(url ?? "")\"")
            #endif
            return url
        }
        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][idCardUrl] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .SignupInfo.idCardImageUrl)
            if let url = newValue {
                keychainWrapper.set(url, forKey: KeychainWrapper.Key.SignupInfo.idCardImageUrl.rawValue)
            }
        }
    }
}

private extension KeychainWrapper.Key {
    enum SignupInfo {
        static let all: KeychainWrapper.Key = "SignupInfo.All"
        static let officeEmail: KeychainWrapper.Key = "SignupInfo.OfficeEmail"
        static let idCardImageUrl: KeychainWrapper.Key = "SignupInfo.IdCardImageURL"
    }
}
