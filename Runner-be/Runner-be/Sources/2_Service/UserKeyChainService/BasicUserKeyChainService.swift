//
//  BasicUserKeyChainService.swift
//  Runner-be
//
//  Created by 김신우 on 2022/03/20.
//

import Foundation
import SwiftKeychainWrapper

final class BasicUserKeyChainService: UserKeychainService {
    static let shared = BasicUserKeyChainService()

    private init(keychainWrapper: KeychainWrapper = .standard) {
        self.keychainWrapper = keychainWrapper
    }

    let keychainWrapper: KeychainWrapper

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
}

private extension KeychainWrapper.Key {
    enum SignupInfo {
        static let uuid: KeychainWrapper.Key = "SignupInfo.uuid"
        static let nickName: KeychainWrapper.Key = "SingupInfo.NickName"
        static let birthday: KeychainWrapper.Key = "SignupInfo.Birthday"
        static let job: KeychainWrapper.Key = "SignupInfo.Job"
        static let gender: KeychainWrapper.Key = "SignupInfo.Gender"
    }
}
