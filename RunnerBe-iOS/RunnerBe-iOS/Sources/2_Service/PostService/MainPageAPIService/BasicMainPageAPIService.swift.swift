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

    init(provider: MoyaProvider<MainPageAPI> = .init(plugins: [VerbosePlugin(verbose: true)])) {
        self.provider = provider
    }

    func fetchPosts(with filter: PostFilter) -> Observable<[Post]?> {
        let functionResult = ReplaySubject<[Post]?>.create(bufferSize: 1)

        let disposable = provider.rx.request(.fetch(filter: filter))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                #if DEBUG
                    print("[MainPageAPIService] fetchPosts with filter: \(filter)")
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
            .map {
                guard let result = $0,
                      let payload = try? result.json["postingresult"].rawData()
                else { return nil }
                return payload
            }
            .compactMap { $0 }
            .decode(type: [PostAPIResult].self, decoder: JSONDecoder())
            .catch { error in
                print("[\(#line):MainPageAPIService] JSON decode Error: \(error)")
                functionResult.onNext(nil)
                return .just([])
            }
            .filter { !$0.isEmpty }
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
        let form = form
        #if DEBUG
            print("[\(#line)BasicMainPageAPI:\(#function)]: \(form)")
        #endif

        return .just(.succeed)
    }
}
