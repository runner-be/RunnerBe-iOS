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

    func detailInfo(postId: Int) -> Observable<DetailInfoResult> {
        let functionResult = ReplaySubject<DetailInfoResult>.create(bufferSize: 1)

        typealias MapResult = (
            bookMarked: Bool,
            isWriter: Bool,
            isApplicant: Bool,
            post: Data,
            participants: Data,
            applicant: Data
        )

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(.error) }

        let disposable = provider.rx.request(.detail(postId: postId, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] Post Detail of id: \(postId) user: \(userId) token: \(token)")
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
            .map { result -> (MapResult?) in

                let postData = (try? result?.json["result"]["postingInfo"].rawData()) ?? Data()
                let participantData = (try? result?.json["result"]["runnerInfo"].rawData()) ?? Data()
                let applicantData = (try? result?.json["result"]["waitingRunnerInfo"].rawData()) ?? Data()
                #if DEBUG
                    print("postData : \n\(postData)")
                    print("participantData : \n\(participantData)")
                    print("applicantData : \n\(applicantData)")
                #endif

                var bookMarked = false
                var writer = false
                var applicant = false

                if let result = result {
                    switch result.response.code {
                    // 성공
                    case 1015: // 성공, 비작성자, 참여신청O, 찜O
                        bookMarked = true
                        applicant = true
                    case 1016: // 성공, 비작성자, 참여신청O, 찜X
                        applicant = true
                    case 1017: // 성공, 비작성자, 참여신청X, 찜O
                        bookMarked = true
                    case 1018: // 성공, 비작성자, 참여신청X, 찜X
                        break
                    case 1019: // 성공, 작성자, 찜O
                        writer = true
                        bookMarked = true
                    case 1020: // 성공, 작성자, 찜X
                        writer = true
                    // 실패
                    case 2010: // jwt와 userId 불일치
                        functionResult.onNext(.error)
                        return nil
                    case 2011: // userId값 필요
                        functionResult.onNext(.error)
                        return nil
                    case 2012: // userId 형식 오류
                        functionResult.onNext(.error)
                        return nil
                    case 2041: // postId 미입력
                        functionResult.onNext(.error)
                        return nil
                    case 2042: // postId 형식오류
                        functionResult.onNext(.error)
                        return nil
                    case 2044: // 인증X 회원
                        functionResult.onNext(.error)
                        return nil
                    case 4000: // 데이터베이스 에러
                        functionResult.onNext(.error)
                        return nil
                    default:
                        functionResult.onNext(.error)
                    }
                }

                return MapResult(
                    bookMarked: bookMarked,
                    isWriter: writer,
                    isApplicant: applicant,
                    post: postData,
                    participants: participantData,
                    applicant: applicantData
                )
            }
            .compactMap { $0 }
            .subscribe(onNext: { result in
                let decoder = JSONDecoder()
                let posts = try? decoder.decode([PostAPIResult].self, from: result.post)
                let participants = (try? decoder.decode([User].self, from: result.participants)) ?? []
                let applicant = (try? decoder.decode([User].self, from: result.applicant)) ?? []

                guard let post = posts?.first
                else {
                    functionResult.onNext(.error)
                    return
                }

                if result.isWriter {
                    functionResult.onNext(.writer(post: post.post, marked: result.bookMarked, participants: participants, applicant: applicant))
                } else {
                    functionResult.onNext(.guest(post: post.post, marked: result.bookMarked, apply: result.isApplicant, participants: participants))
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

    func apply(postId: Int) -> Observable<Bool> {
        let functionResult = ReplaySubject<Bool>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(false) }

        let disposable = provider.rx.request(.apply(postId: postId, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (BasicResponse?) in
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] apply postId:\(postId) userId: \(userId) token: \(token.jwt)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result == fail")
                        functionResult.onNext(false)
                    #endif
                    return nil
                }

                return try? BasicResponse(json: json)
            }
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext(false)
                    return
                }
                #if DEBUG
                    print("response Message: \(response.message)")
                #endif
                switch response.code {
                case 1000: // 성공
                    functionResult.onNext(true)
                case 2010: // jwt와 userId 불일치
                    functionResult.onNext(false)
                case 2011: // userId값 필요
                    functionResult.onNext(false)
                case 2012: // userId 형식 오류
                    functionResult.onNext(false)
                case 2041: // postId 미입력
                    functionResult.onNext(false)
                case 2042: // postId 형식오류
                    functionResult.onNext(false)
                case 2044: // 인증 대기중 회원
                    functionResult.onNext(false)
                case 2064: // 이미 신청한 유저
                    functionResult.onNext(false)
                default:
                    functionResult.onNext(false)
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

    func accept(postId: Int, applicantId: Int, accept: Bool) -> Observable<(id: Int, success: Bool)> {
        let functionResult = ReplaySubject<(id: Int, success: Bool)>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just((id: applicantId, success: false)) }

        let disposable = provider.rx.request(
            .accept(
                postId: postId,
                userId: userId,
                applicantId: applicantId,
                accept: accept,
                token: token
            )
        )
        .asObservable()
        .map { try? JSON(data: $0.data) }
        .map { json -> (BasicResponse?) in
            #if DEBUG
                print("[\(#line):MainPageAPIService:\(#function)] accpet postId: \(postId), applicant: \(applicantId)")
            #endif
            guard let json = json
            else {
                #if DEBUG
                    print("result == fail")
                    functionResult.onNext((id: applicantId, success: false))
                #endif
                return nil
            }

            return try? BasicResponse(json: json)
        }
        .subscribe(onNext: { response in
            guard let response = response else {
                functionResult.onNext((id: applicantId, success: false))
                return
            }
            #if DEBUG
                print("response Message: \(response.message)")
            #endif
            switch response.code {
            case 1000: // 성공
                functionResult.onNext((id: applicantId, success: true))
            case 2010: // jwt와 userId 불일치
                functionResult.onNext((id: applicantId, success: false))
            case 2011: // userId값 필요
                functionResult.onNext((id: applicantId, success: false))
            case 2012: // userId 형식 오류
                functionResult.onNext((id: applicantId, success: false))
            case 2041: // postId 미입력
                functionResult.onNext((id: applicantId, success: false))
            case 2042: // postId 형식오류
                functionResult.onNext((id: applicantId, success: false))
            case 2044: // 인증 대기중 회원
                functionResult.onNext((id: applicantId, success: false))
            case 2065: // applicantId 미입력
                functionResult.onNext((id: applicantId, success: false))
            case 2066: // applicantId 형식오류
                functionResult.onNext((id: applicantId, success: false))
            case 2067: // 수락 권한 없음
                functionResult.onNext((id: applicantId, success: false))
            case 2068: // accept 여부 미입력
                functionResult.onNext((id: applicantId, success: false))
            case 2069: // accept 형식 오류 "Y" "D"
                functionResult.onNext((id: applicantId, success: false))
            case 2070: // applicant 유저가 모임 대기상태가 아닙니다.
                functionResult.onNext((id: applicantId, success: false))
            default:
                functionResult.onNext((id: applicantId, success: false))
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

    func close(postId: Int) -> Observable<Bool> {
        let functionResult = ReplaySubject<Bool>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(false) }

        let disposable = provider.rx.request(.close(postId: postId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (BasicResponse?) in
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] close postId:\(postId) token: \(token.jwt)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result == fail")
                        functionResult.onNext(false)
                    #endif
                    return nil
                }

                return try? BasicResponse(json: json)
            }
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext(false)
                    return
                }
                #if DEBUG
                    print("response Message: \(response.message)")
                #endif
                switch response.code {
                case 1000: // 성공
                    functionResult.onNext(true)
                case 2043:
                    functionResult.onNext(false)
                case 2044: // 인증 대기중 회원
                    functionResult.onNext(false)
                default:
                    functionResult.onNext(false)
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

    func myPage() -> Observable<MyPageAPIResult> {
        let functionResult = ReplaySubject<MyPageAPIResult>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(.error) }

        typealias RawDatas = (userData: Data, postingData: Data, joinedData: Data)

        let disposable = provider.rx.request(.myPage(userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] MyPage user: \(userId) token: \(token)")
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
            .map { result -> RawDatas? in

                let userData = (try? result?.json["result"]["myInfo"].rawData()) ?? Data()
                let postingData = (try? result?.json["result"]["myPosting"].rawData()) ?? Data()
                let joinedData = (try? result?.json["result"]["myRunning"].rawData()) ?? Data()
                #if DEBUG
                    print("userData : \n\(userData)")
                    print("postingData : \n\(postingData)")
                    print("joinedData : \n\(joinedData)")
                #endif

                if let result = result {
                    switch result.response.code {
                    // 성공
                    case 1000: // 성공, 비작성자, 참여신청O, 찜O
                        break
                    case 2010: // jwt와 userId 불일치
                        functionResult.onNext(.error)
                        return nil
                    case 2011: // userId값 필요
                        functionResult.onNext(.error)
                        return nil
                    case 2012: // userId 형식 오류
                        functionResult.onNext(.error)
                        return nil
                    case 2044: // 인증X 회원
                        functionResult.onNext(.error)
                        return nil
                    default:
                        functionResult.onNext(.error)
                        return nil
                    }
                }
                return (userData: userData, postingData: postingData, joinedData: joinedData)
            }
            .compactMap { $0 }
            .subscribe(onNext: { result in
                let decoder = JSONDecoder()
                let userInfo = try? decoder.decode([User].self, from: result.userData).first
                let posting = (try? decoder.decode([PostAPIResult].self, from: result.postingData)) ?? []
                let joined = (try? decoder.decode([PostAPIResult].self, from: result.joinedData)) ?? []

                let userPosting = posting.reduce(into: [Post]()) { $0.append($1.post) }
                let userJoined = joined.reduce(into: [Post]()) { $0.append($1.post) }

                if let user = userInfo {
                    functionResult.onNext(.success(info: user, posting: userPosting, joined: userJoined))
                } else {
                    functionResult.onNext(.error)
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

    func attendance(postId: Int) -> Observable<(postId: Int, success: Bool)> {
        let functionResult = ReplaySubject<(postId: Int, success: Bool)>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just((postId: postId, success: false)) }

        let disposable = provider.rx.request(.attendance(postId: postId, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (BasicResponse?) in
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] attending postId:\(postId)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("[\(#line):MainPageAPIService:\(#function)] attending postId:\(postId) -> failed")
                    #endif
                    functionResult.onNext((postId: postId, success: false))
                    return nil
                }

                return try? BasicResponse(json: json)
            }
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext((postId: postId, success: false))
                    return
                }
                #if DEBUG
                    print("[\(#line):MainPageAPIService:\(#function)] response message: \(response.message)")
                #endif
                switch response.code {
                case 1000: // 성공
                    #if DEBUG
                        print("[\(#line):MainPageAPIService:\(#function)] attending postId:\(postId) -> success")
                    #endif
                    functionResult.onNext((postId: postId, success: true))
                case 2010: // jwt와 userId 불일치
                    functionResult.onNext((postId: postId, success: false))
                case 2011: // userId 미입력
                    functionResult.onNext((postId: postId, success: false))
                case 2012: // userId 형식 오류 (숫자입력 X)
                    functionResult.onNext((postId: postId, success: false))
                case 2041: // postId 미입력
                    functionResult.onNext((postId: postId, success: false))
                case 2042: // postId 형식 오류
                    functionResult.onNext((postId: postId, success: false))
                case 2044: // 인증 대기중 회원
                    functionResult.onNext((postId: postId, success: false))
                case 2077: // 유저가 해당 러닝모임에 속하지 않습니다.
                    functionResult.onNext((postId: postId, success: false))
                default:
                    functionResult.onNext((postId: postId, success: false))
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
