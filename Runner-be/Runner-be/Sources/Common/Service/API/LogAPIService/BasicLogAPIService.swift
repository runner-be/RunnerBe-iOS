//
//  BasicLogAPIService.swift
//  Runner-be
//
//  Created by 김창규 on 9/4/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicLogAPIService: LogAPIService {
    private var disposabledId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<LogAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<LogAPI> = .init(plugins: [VerbosePlugin(verbose: true)]), loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }

    func fetchLog(
        year: String,
        month: String
    ) -> Observable<APIResult<(year: String, month: String)>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(APIResult.response(result: (year: year, month: month)))
        }
        return provider.rx.request(.fetchLog(
            userId: userId,
            year: year,
            month: month,
            token: token
        ))
        .asObservable()
        .mapResponse()
        .map { response in
            guard let response = response else {
                Log.d(tag: .network, "res")
                return APIResult.response(result: (year: year, month: month))
            }

            Log.d(tag: .network, "response message: \(response.basic.message)")
            switch response.basic.code {
            case 1000: // 성공
                return APIResult.response(result: (year: year, month: month))
            case 2010: // jwt의 userId와 userId가 일치하지 않습니다.
                return APIResult.response(result: (year: year, month: month))
            case 2115: // 연도를 입력해 주세요.
                return APIResult.response(result: (year: year, month: month))
            case 2116: // 월 단위를 입력해 주세요.
                return APIResult.response(result: (year: year, month: month))
            default:
                return APIResult.response(result: (year: year, month: month))
            }
        }
        .timeout(.seconds(2), scheduler: MainScheduler.instance)
        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func fetchStamp() {}

    func create() {}

    func eidt() {}

    func delete() {}

    func detail() {}
}
