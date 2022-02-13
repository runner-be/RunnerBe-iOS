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

    init(keychainWrapper: KeychainWrapper = .standard) {
        self.keychainWrapper = keychainWrapper
    }

    var signupForm: SignupForm {
        get {
            SignupForm(
                uuid: uuid,
                nickName: nickName,
                birthday: birthDay,
                gender: gender,
                job: job,
                officeEmail: officeMail,
                idCardImageUrl: idCardUrl
            )
        }
        set {
            uuid = newValue.uuid
            nickName = newValue.nickName
            birthDay = newValue.birthday
            gender = newValue.gender
            job = newValue.job
            officeMail = newValue.officeEmail
            idCardUrl = newValue.idCardImageUrl
        }
    }

    var uuid: String {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][uuid] get")
            #endif
            guard let uuid: String = keychainWrapper[.SignupInfo.uuid]
            else {
                #if DEBUG
                    print("\t= \"\"")
                #endif
                return ""
            }
            #if DEBUG
                print("\t= \"\(uuid)\"")
            #endif
            return uuid
        }

        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][uuid] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .SignupInfo.uuid)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.SignupInfo.uuid.rawValue)
        }
    }

    var nickName: String {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][nickName] get")
            #endif
            guard let nickName: String = keychainWrapper[.SignupInfo.nickName]
            else {
                #if DEBUG
                    print("\t= \"\"")
                #endif
                return ""
            }
            #if DEBUG
                print("\t= \"\(nickName)\"")
            #endif
            return nickName
        }
        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][nickName] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .SignupInfo.nickName)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.SignupInfo.nickName.rawValue)
        }
    }

    var birthDay: Int {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][birthDay] get")
            #endif
            guard let birthDay: Int = keychainWrapper[.SignupInfo.birthday]
            else {
                #if DEBUG
                    print("\t= \"\"")
                #endif
                return 0
            }
            #if DEBUG
                print("\t= \"\(birthDay)\"")
            #endif
            return birthDay
        }
        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][birthDay] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .SignupInfo.birthday)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.SignupInfo.birthday.rawValue)
        }
    }

    var job: Job {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][job] get")
            #endif
            guard let job: String = keychainWrapper[.SignupInfo.job]
            else {
                #if DEBUG
                    print("\t= \"\"")
                #endif
                return Job.none
            }
            #if DEBUG
                print("\t= \"\(job)\"")
            #endif

            return Job(code: job)
        }
        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][job] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .SignupInfo.job)
            keychainWrapper.set(newValue.code, forKey: KeychainWrapper.Key.SignupInfo.job.rawValue)
        }
    }

    var gender: Gender {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][gender] get")
            #endif
            guard let gender: String = keychainWrapper[.SignupInfo.gender]
            else {
                #if DEBUG
                    print("\t= \"\"")
                #endif
                return Gender.none
            }
            #if DEBUG
                print("\t= \"\(gender)\"")
            #endif
            return Gender(code: gender)
        }

        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][gender] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .SignupInfo.gender)
            keychainWrapper.set(newValue.code, forKey: KeychainWrapper.Key.SignupInfo.gender.rawValue)
        }
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
        static let uuid: KeychainWrapper.Key = "SignupInfo.uuid"
        static let nickName: KeychainWrapper.Key = "SingupInfo.NickName"
        static let birthday: KeychainWrapper.Key = "SignupInfo.Birthday"
        static let job: KeychainWrapper.Key = "SignupInfo.Job"
        static let gender: KeychainWrapper.Key = "SignupInfo.Gender"
        static let officeEmail: KeychainWrapper.Key = "SignupInfo.OfficeEmail"
        static let idCardImageUrl: KeychainWrapper.Key = "SignupInfo.IdCardImageURL"
    }
}
