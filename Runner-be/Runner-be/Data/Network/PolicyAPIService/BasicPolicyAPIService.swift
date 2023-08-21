//
//  BasicPolicyAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//

import Foundation
import Moya
import RxSwift

final class BasicPolicyAPIService: PolicyAPIService {
    private var provider: MoyaProvider<PolicyAPI>

    init(provider: MoyaProvider<PolicyAPI> = .init()) {
        self.provider = provider
    }

    func policy(type: PolicyType) -> Observable<String> {
        return provider.rx.request(.policy(type: type))
            .asObservable()
            .map { response in
                if response.statusCode >= 200, response.statusCode < 300 {
                    let str = String(data: response.data, encoding: .utf8)
                    return str ?? type.contents
                } else {
                    return type.contents
                }
            }
    }
}
