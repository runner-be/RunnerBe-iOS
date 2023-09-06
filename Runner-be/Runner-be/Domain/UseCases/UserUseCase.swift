//
//  UserUseCase.swift
//  Runner-be
//
//  Created by 이유리 on 2023/08/27.
//

import Foundation
import RxSwift

final class UserUseCase {
    private var userKeyChainRepo: UserKeychainService = BasicUserKeyChainService.shared
    private var userAPIRepo: UserAPIService = BasicUserAPIService()

    // MARK: - Network

    func checkAlarms() -> Observable<Bool> {
        return userAPIRepo.checkAlarms()
    }

    func fetchAlarms() -> Observable<[Alarm]?> {
        return userAPIRepo.fetchAlarms()
    }

    func setJob(to job: Job) -> Observable<Bool> {
        return userAPIRepo.setJob(to: job)
    }

    func setNickName(to _: String) -> Observable<SetNickNameResult> {
        return userAPIRepo.setNickName(to: nickName)
    }
}

// MARK: - Keychain

extension UserUseCase {
    var uuid: String { return userKeyChainRepo.uuid }

    var deviceToken: String { return userKeyChainRepo.deviceToken }

    var nickName: String { return userKeyChainRepo.nickName }

    var birthDay: Int { return userKeyChainRepo.birthDay }

    var job: Job { return userKeyChainRepo.job }

    var gender: Gender { return userKeyChainRepo.gender }

    func clear() {
        userKeyChainRepo.clear()
    }

    func setBirthday(birthday: Int) {
        userKeyChainRepo.birthDay = birthday
    }

    func setGender(gender: Gender) {
        userKeyChainRepo.gender = gender
    }

    func setJob(job: Job) {
        userKeyChainRepo.job = job
    }
}
