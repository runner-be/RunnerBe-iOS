//
//  BasicPostAPIService.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicPostAPIService: PostAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<PostAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<PostAPI> = .init(plugins: [VerbosePlugin(verbose: true)]), loginKeyChainService: LoginKeyChainService) {
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
                $0.append($1.post)
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
                #if DEBUG
                    print("response Message: \(response.message)")
                #endif
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

    func bookmark(postId: Int, mark: Bool) -> Observable<(postId: Int, mark: Bool)> {
        let functionResult = ReplaySubject<(postId: Int, mark: Bool)>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just((postId: postId, mark: !mark)) }

        let disposable = provider.rx.request(.bookmarking(postId: postId, userId: userId, mark: mark, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (BasicResponse?) in
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] bookmarking postId:\(postId) -> \(mark)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result == fail")
                        functionResult.onNext((postId: postId, mark: !mark))
                    #endif
                    return nil
                }

                return try? BasicResponse(json: json)
            }
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext((postId: postId, mark: !mark))
                    return
                }
                #if DEBUG
                    print("response Message: \(response.message)")
                #endif
                switch response.code {
                case 1000: // 성공
                    functionResult.onNext((postId: postId, mark: mark))
                case 2011: // userId 미입력
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2012: // userId 형식 오류 (숫자입력 X)
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2041: // postId 미입력
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2042: // postId 형식 오류
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2044: // 인증 대기중 회원
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2071: // 찜 등록/ 해제 미입력
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2072: // 찜 등록/ 해제 형식 오류 (Y,N)으로 입력
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2073: // 이미 찜 등록중
                    functionResult.onNext((postId: postId, mark: !mark))
                case 2074: // 이미 찜 해제함
                    functionResult.onNext((postId: postId, mark: !mark))
                case 4000: // 데이터베이스 에러
                    functionResult.onNext((postId: postId, mark: !mark))
                default:
                    functionResult.onNext((postId: postId, mark: !mark))
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

    func fetchPostsBookMarked() -> Observable<[Post]?> {
        let functionResult = ReplaySubject<[Post]?>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(nil) }

        let disposable = provider.rx.request(.fetchBookMarked(userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] fetchBookMarkList of user: \(userId) token: \(token)")
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
            .map { (try? $0?.json["result"]["bookMarkList"].rawData()) ?? Data() }
            .decode(type: [PostAPIResult]?.self, decoder: JSONDecoder())
            .catch { error in
                print(error.localizedDescription)
                return .just(nil)
            }
            .map { $0?.reduce(into: [Post]()) {
                $0.append($1.post)
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
}
