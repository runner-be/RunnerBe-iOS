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
    case error
}

enum SetJobResult {
    case success
    case error
}

enum SetProfileResult {
    case success(data: Data)
    case error
}

protocol UserAPIService {
    func setNickName(to name: String) -> Observable<SetNickNameResult>
    func setJob(to job: Job) -> Observable<SetJobResult>
    func setProfileImage(to image: Data) -> Observable<SetProfileResult>
}
