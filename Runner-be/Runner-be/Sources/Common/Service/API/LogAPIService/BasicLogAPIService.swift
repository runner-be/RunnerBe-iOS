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

    func create(form: LogForm) -> Observable<APIResult<LogResult>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(APIResult.response(result: LogResult.fail))
        }
        return provider.rx.request(.create(
            createLogRequest: form,
            userId: userId,
            token: token
        ))
        .asObservable()
        .mapResponse()
        .map { response in
            guard let response = response else {
                Log.d(tag: .network, "res")
                return APIResult.response(result: LogResult.fail)
            }

            Log.d(tag: .network, "response message: \(response.basic.message)")
            switch response.basic.code {
            case 1000: // 성공
                return APIResult.response(result: LogResult.succeed)
            case 2010: // jwt의 userId와 userId가 일치하지 않습니다.
                return APIResult.response(result: LogResult.fail)
            case 2011: // userId 값을 입력해주세요.
                return APIResult.response(result: LogResult.fail)
            case 2109: // 러닝로그 날짜를 입력해주세요.
                return APIResult.response(result: LogResult.fail)
            case 2110: // 러닝 스탬프 코드를 입력해주세요.
                return APIResult.response(result: LogResult.fail)
            case 2111: // 러닝 날씨 기온을 입력해주세요.
                return APIResult.response(result: LogResult.fail)
            case 2026: // 자유 내용은 500자 이내로 입력해줴요.
                return APIResult.response(result: LogResult.fail)
            case 2112: // 러닝 날짜는 YYYY-MM-DD 형태로 입력해주세요.
                return APIResult.response(result: LogResult.fail)
            default:
                return APIResult.response(result: LogResult.fail)
            }
        }
        .timeout(.seconds(2), scheduler: MainScheduler.instance)
        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func eidt() {}

    func delete() {}

    func detail() {}
}
