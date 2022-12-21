//
//  UserAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/28.
//

import Foundation
import RxSwift

enum SetNickNameResult {
    case succeed(name: String)
    case duplicated
    case alreadyChanged
    case error
}

enum SetJobResult {
    case succeed
    case error
}

enum SetProfileResult {
    case succeed(data: Data)
    case error
}

protocol UserAPIService {
    func setNickName(to name: String) -> Observable<SetNickNameResult>
    func setJob(to job: Job) -> Observable<SetJobResult>
    func setProfileImage(to image: Data) -> Observable<SetProfileResult>
    func signout() -> Observable<Bool>
    func fetchAlarms() -> Observable<[Alarm]?>
    func checkAlarms() -> Observable<Bool>
}
