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
            guard let uuid: String = keychainWrapper[.User.uuid]
            else {
                Log.d(tag: .info, "get uuid: nil")
                return ""
            }
            Log.d(tag: .info, "get uuid: \(uuid)")
            return uuid
        }

        set {
            Log.d(tag: .info, "set uuid: \(newValue ?? "nil")")
            keychainWrapper.remove(forKey: .User.uuid)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.uuid.rawValue)
        }
    }

    var deviceToken: String {
        get {
            guard let deviceToken: String = keychainWrapper[.User.deviceToken]
            else {
                Log.d(tag: .info, "get deviceToken: nil")
                return ""
            }
            Log.d(tag: .info, "get deviceToken: \(deviceToken)")
            return deviceToken
        }

        set {
            Log.d(tag: .info, "set deviceToken: \(newValue ?? "nil")")
            keychainWrapper.remove(forKey: .User.deviceToken)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.deviceToken.rawValue)
        }
    }

    var nickName: String {
        get {
            guard let nickName: String = keychainWrapper[.User.nickName]
            else {
                Log.d(tag: .info, "get nickName: \"\"")
                return ""
            }
            Log.d(tag: .info, "get nickName: \(nickName)")
            return nickName
        }
        set {
            Log.d(tag: .info, "set nickName: \(newValue ?? "nil")")
            keychainWrapper.remove(forKey: .User.nickName)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.nickName.rawValue)
        }
    }

    var birthDay: Int {
        get {
            guard let birthDay: Int = keychainWrapper[.User.birthday]
            else {
                Log.d(tag: .info, "get birth: 0")
                return 0
            }
            Log.d(tag: .info, "get birth: \(birthDay)")
            return birthDay
        }
        set {
            Log.d(tag: .info, "set birth: \(newValue)")
            keychainWrapper.remove(forKey: .User.birthday)
            keychainWrapper.set(newValue, forKey: KeychainWrapper.Key.User.birthday.rawValue)
        }
    }

    var job: Job {
        get {
            guard let job: String = keychainWrapper[.User.job]
            else {
                Log.d(tag: .info, "get job: none")
                return Job.none
            }
            Log.d(tag: .info, "get job: \(job)")

            return Job(code: job)
        }
        set {
            Log.d(tag: .info, "set job: \(newValue)")
            keychainWrapper.remove(forKey: .User.job)
            keychainWrapper.set(newValue.code, forKey: KeychainWrapper.Key.User.job.rawValue)
        }
    }

    var gender: Gender {
        get {
            guard let gender: String = keychainWrapper[.User.gender]
            else {
                Log.d(tag: .info, "get gender: none")
                return Gender.none
            }
            Log.d(tag: .info, "get gender: \(gender)")
            return Gender(code: gender)
        }

        set {
            Log.d(tag: .info, "set gender: \(newValue)")
            keychainWrapper.remove(forKey: .User.gender)
            keychainWrapper.set(newValue.code, forKey: KeychainWrapper.Key.User.gender.rawValue)
        }
    }

    func clear() {
        uuid = ""
        nickName = ""
        birthDay = 0
        job = Job.none
        gender = Gender.none
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
