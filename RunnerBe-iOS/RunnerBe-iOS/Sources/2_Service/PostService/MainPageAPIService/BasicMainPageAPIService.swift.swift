//
//  BasicMainPageAPIService.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicMainPageAPIService: MainPageAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<MainPageAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<MainPageAPI> = .init(), loginKeyChainService: LoginKeyChainService) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }

    func fetchPosts(with filter: PostFilter) -> Observable<[Post]?> {
        let functionResult = ReplaySubject<[Post]?>.create(bufferSize: 1)

        let disposable = provider.rx.request(.fetch(filter: filter))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                #if DEBUG
                    print("[MainPageAPIService] fetchPosts with filter: \n\(filter)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result == nil")
                    #endif
                    return nil
                }
                #if DEBUG
                    print("result: \n\(json)")
                #endif
                return try? (response: BasicResponse(json: json), json: json)
            }
            .map { try? $0?.json["result"].rawData() }
            .compactMap { $0 }
            .decode(type: [PostAPIResult].self, decoder: JSONDecoder())
            .map { $0.reduce(into: [Post]()) {
                $0.append(Post(from: $1))
            }}
            .bind(to: functionResult)

        let id = disposableId
        disposableId += 1
        disposableDic[disposableId] = disposable

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposableDic[id]?.dispose()
                self?.disposableDic.removeValue(forKey: id)
            })
    }

    func posting(form: PostingForm) -> Observable<PostingResult> {
        #if DEBUG
            print("[\(#line)BasicMainPageAPI:\(#function)]: \(form)")
        #endif

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(.needLogin)
        }
        let functionResult = ReplaySubject<PostingResult>.create(bufferSize: 1)

        let disposable = provider.rx.request(.posting(form: form, id: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (BasicResponse?) in
                #if DEBUG
                    print("[\(#line)MainPageAPIService:\(#function)] posting with form: \n\(form)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result == nil")
                        functionResult.onNext(.fail)
                    #endif
                    return nil
                }

                return try? BasicResponse(json: json)
            }
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext(.fail)
                    return
                }
                print(response.message)

                switch response.code {
                case 1000: // 성공
                    functionResult.onNext(.succeed)
                case 2010, 2011, 2012, 2044, 3006: // 유저 로그인 필요
                    functionResult.onNext(.needLogin)
                case 4000: // db에러
                    functionResult.onNext(.fail)
                default: // 나머지 에러
                    functionResult.onNext(.fail)
                }
            })

        let id = disposableId
        disposableId += 1
        disposableDic[disposableId] = disposable

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposableDic[id]?.dispose()
                self?.disposableDic.removeValue(forKey: id)
            })
    }
}
