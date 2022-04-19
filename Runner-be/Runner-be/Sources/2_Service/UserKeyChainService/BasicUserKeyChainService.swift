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
            guard let uuid: String = keychainWrapper[.User.uuid]
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
            keychainWrapper.remove(forKey: .User.uuid)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.uuid.rawValue)
        }
    }

    var deviceToken: String {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][deviceToken] get")
            #endif
            guard let deviceToken: String = keychainWrapper[.User.deviceToken]
            else {
                #if DEBUG
                    print("\t= \"\"")
                #endif
                return ""
            }
            #if DEBUG
                print("\t= \"\(deviceToken)\"")
            #endif
            return deviceToken
        }

        set {
            #if DEBUG
                print("[BasicSignupKeyChainService][deviceToken] set\n\t= \"\(newValue)\"")
            #endif
            keychainWrapper.remove(forKey: .User.deviceToken)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.deviceToken.rawValue)
        }
    }

    var nickName: String {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][nickName] get")
            #endif
            guard let nickName: String = keychainWrapper[.User.nickName]
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
            keychainWrapper.remove(forKey: .User.nickName)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.nickName.rawValue)
        }
    }

    var birthDay: Int {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][birthDay] get")
            #endif
            guard let birthDay: Int = keychainWrapper[.User.birthday]
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
            keychainWrapper.remove(forKey: .User.birthday)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.birthday.rawValue)
        }
    }

    var job: Job {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][job] get")
            #endif
            guard let job: String = keychainWrapper[.User.job]
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
            keychainWrapper.remove(forKey: .User.job)
            keychainWrapper.set(newValue.code, forKey: KeychainWrapper.Key.User.job.rawValue)
        }
    }

    var gender: Gender {
        get {
            #if DEBUG
                print("[BasicSignupKeyChainService][gender] get")
            #endif
            guard let gender: String = keychainWrapper[.User.gender]
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
            keychainWrapper.remove(forKey: .User.gender)
            keychainWrapper.set(newValue.code, forKey: KeychainWrapper.Key.User.gender.rawValue)
        }
    }
}

private extension KeychainWrapper.Key {
    enum User {
        static let uuid: KeychainWrapper.Key = "SignupInfo.uuid"
        static let deviceToken: KeychainWrapper.Key = "User.deviceToken"
        static let nickName: KeychainWrapper.Key = "SingupInfo.NickName"
        static let birthday: KeychainWrapper.Key = "SignupInfo.Birthday"
        static let job: KeychainWrapper.Key = "SignupInfo.Job"
        static let gender: KeychainWrapper.Key = "SignupInfo.Gender"
    }
}
