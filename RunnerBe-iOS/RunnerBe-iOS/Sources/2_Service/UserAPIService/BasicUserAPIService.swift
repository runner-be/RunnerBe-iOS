//
//  BasicUserAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/28.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicUserAPIService: UserAPIService {
    private var imageUploadService: ImageUploadService
    private var loginKeyChainService: LoginKeyChainService
    private var provider: MoyaProvider<UserAPI>
    init(
        provider: MoyaProvider<UserAPI> = .init(plugins: [VerbosePlugin(verbose: true)]),
        loginKeyChainService: LoginKeyChainService,
        imageUploadService: ImageUploadService
    ) {
        self.provider = provider
        self.loginKeyChainService = loginKeyChainService
        self.imageUploadService = imageUploadService
    }

    func setNickName(to _: String) -> Observable<SetNickNameResult> {
        return .just(.success)
    }

    func setJob(to _: Job) -> Observable<SetJobResult> {
        return .just(.success)
    }

    func setProfileImage(to _: Data) -> Observable<SetProfileResult> {
        return .just(.success)
    }
}
