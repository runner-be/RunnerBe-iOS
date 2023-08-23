//
//  MessageAPIService.swift
//  Runner-be
//
//  Created by 이유리 on 2023/01/18.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicMessageAPIService: MessageAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<MessageAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<MessageAPI> = .init(plugins: [VerbosePlugin(verbose: true)]), loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }

    func getMessageRoomList() -> Observable<APIResult<[MessageRoom]?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getMessageList(token: token))
            .asObservable() // return type을 observable로
            .mapResponse()
            .map { (try? $0?.json["result"].rawData()) ?? Data() } // result에 해당하는 rawData
            .decode(type: [MessageRoom]?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0 ?? []) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }

    func getMessageContents(roomId: Int) -> Observable<APIResult<GetMessageRoomInfoResult?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getMessageRoomContents(roomId: roomId, token: token))
            .asObservable() // return type을 observable로
            .mapResponse()
            .map { (try? $0?.json["result"].rawData()) ?? Data() } // result에 해당하는 rawData
            .decode(type: GetMessageRoomInfoResult?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }

    func postMessage(roomId: Int, content: String) -> Observable<APIResult<Bool>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.postMessage(roomId: roomId, postMessageRequest: PostMessageRequest(content: content), token: token))
            .asObservable()
            .mapResponse()
            .map { response in
                guard let response = response else {
                    Log.d(tag: .network, "result: fail")
                    return .error(alertMessage: nil)
                }

                Log.d(tag: .network, "response message: \(response.basic.message)")
                switch response.basic.code {
                case 1000: // 성공
                    return .response(result: true)
                default: // 나머지 에러
                    return .error(alertMessage: "오류가 발생했습니다. 다시 시도해주세요.")
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func reportMessages(reportMessageIndexString: String) -> Observable<APIResult<Bool>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.reportMessage(token: token, postReportMessageRequest: PostMessageReportRequest(messageIdList: reportMessageIndexString)))
            .asObservable()
            .mapResponse()
            .map { response in
                guard let response = response else {
                    Log.d(tag: .network, "result: fail")
                    return .error(alertMessage: nil)
                }

                Log.d(tag: .network, "response message: \(response.basic.message)")
                switch response.basic.code {
                case 1000: // 성공
                    return .response(result: true)
                default: // 나머지 에러
                    return .error(alertMessage: "오류가 발생했습니다. 다시 시도해주세요.")
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
}
