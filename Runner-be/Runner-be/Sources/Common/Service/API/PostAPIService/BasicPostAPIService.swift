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

    init(provider: MoyaProvider<PostAPI> = .init(plugins: [VerbosePlugin(verbose: true)]), loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }

    func fetchPosts(with filter: PostFilter) -> Observable<APIResult<[Post]?>> {
        return provider.rx.request(.fetch(userId: loginKeyChain.userId, filter: filter))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                guard let json = json
                else {
                    Log.d(tag: .network, "result: fail")
                    return nil
                }
                return try? (response: BasicResponse(json: json), json: json)
            }
            .map { try? $0?.json["result"].rawData() }
            .compactMap { $0 }
            .decode(type: [PostResponse].self, decoder: JSONDecoder())
            .map { APIResult.response(result: $0.compactMap { $0.convertedPost }) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func posting(form: PostingForm) -> Observable<APIResult<PostingResult>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(APIResult.response(result: .needLogin))
        }

        return provider.rx.request(.posting(form: form, id: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { try? BasicResponse(json: $0) }
            .map { response in
                guard let response = response else {
                    Log.d(tag: .network, "result: fail")
                    return .error(alertMessage: nil)
                }

                Log.d(tag: .network, "response message: \(response.message)")
                switch response.code {
                case 1000: // 성공
                    return .response(result: .succeed)
                case 2010, 2011, 2012, 2044, 3006: // 유저 로그인 필요
                    return .response(result: .needLogin)
                case 2095: // 성별 불가
                    return .error(alertMessage: response.message)
                case 4000: // db에러
                    return .error(alertMessage: nil)
                default: // 나머지 에러
                    return .error(alertMessage: nil)
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func bookmark(postId: Int, mark: Bool) -> Observable<APIResult<(postId: Int, mark: Bool)>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(APIResult.response(result: (postId: postId, mark: !mark)))
        }

        return provider.rx.request(.bookmarking(postId: postId, userId: userId, mark: mark, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { try? BasicResponse(json: $0) }
            .map { response in
                guard let response = response else {
                    Log.d(tag: .network, "res")
                    return APIResult.response(result: (postId: postId, mark: !mark))
                }

                Log.d(tag: .network, "response message: \(response.message)")
                switch response.code {
                case 1000: // 성공
                    return APIResult.response(result: (postId: postId, mark: mark))
                case 2011: // userId 미입력
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2012: // userId 형식 오류 (숫자입력 X)
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2041: // postId 미입력
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2042: // postId 형식 오류
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2044: // 인증 대기중 회원
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2071: // 찜 등록/ 해제 미입력
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2072: // 찜 등록/ 해제 형식 오류 (Y,N)으로 입력
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2073: // 이미 찜 등록중
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 2074: // 이미 찜 해제함
                    return APIResult.response(result: (postId: postId, mark: !mark))
                case 4000: // 데이터베이스 에러
                    return APIResult.response(result: (postId: postId, mark: !mark))
                default:
                    return APIResult.response(result: (postId: postId, mark: !mark))
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func fetchPostsBookMarked() -> Observable<APIResult<[Post]?>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.fetchBookMarked(userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in

                guard let json = json
                else {
                    Log.d(tag: .network, "result: fail")
                    return nil
                }

                return try? (response: BasicResponse(json: json), json: json)
            }
            .map { (try? $0?.json["result"]["bookMarkList"].rawData()) ?? Data() }
            .decode(type: [PostResponse]?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error.localizedDescription)")
                return .just(nil)
            }
            .map { $0?.compactMap { $0.convertedPost } }
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func detailInfo(postId: Int) -> Observable<APIResult<DetailInfoResult>> {
        typealias MapResult = (
            bookMarked: Bool,
            isWriter: Bool,
            isApplicant: Bool,
            post: Data,
            participants: Data,
            applicant: Data,
            roomID: Int?
        )

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.detail(postId: postId, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                guard let json = json
                else {
                    Log.d(tag: .network, "result: fail")
                    return nil
                }

                return try? (response: BasicResponse(json: json), json: json)
            }
            .map { result -> (MapResult?) in

                let postData = (try? result?.json["result"]["postingInfo"].rawData()) ?? Data()
                let participantData = (try? result?.json["result"]["runnerInfo"].rawData()) ?? Data()
                let applicantData = (try? result?.json["result"]["waitingRunnerInfo"].rawData()) ?? Data()
                let roomID = (try? result?.json["result"]["roomId"].int)

                Log.d(tag: .info, """
                postData :
                \(postData)
                participantData :
                \(participantData)
                applicantData :
                \(applicantData)
                """)

                var bookMarked = false
                var writer = false
                var applicant = false
                if let result = result {
                    Log.d(tag: .network, "detailInfo(postId:\(postId)) resultCode: \(result.response.code)")
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
                        return nil
                    case 2011: // userId값 필요
                        return nil
                    case 2012: // userId 형식 오류
                        return nil
                    case 2041: // postId 미입력
                        return nil
                    case 2042: // postId 형식오류
                        return nil
                    case 2044: // 인증X 회원
                        return nil
                    case 4000: // 데이터베이스 에러
                        return nil
                    default:
                        return nil
                    }
                } else {
                    Log.d(tag: .network, "detailInfo(postId:\(postId)) network Error no Response")
                }

                return MapResult(
                    bookMarked: bookMarked,
                    isWriter: writer,
                    isApplicant: applicant,
                    post: postData,
                    participants: participantData,
                    applicant: applicantData,
                    roomID: roomID
                )
            }
            .compactMap { $0 }
            .map { result in
                let decoder = JSONDecoder()
                let posts = try? decoder.decode([DetailPostResponse].self, from: result.post)
                let participants = (try? decoder.decode([UserResponse].self, from: result.participants))?.map { $0.userInfo } ?? []
                let applicant = (try? decoder.decode([UserResponse].self, from: result.applicant))?.map { $0.userInfo } ?? []

                guard let postDetail = posts?.first?.convertedDetailPost
                else {
                    return APIResult.error(alertMessage: nil)
                }

                if result.isWriter {
                    return APIResult.response(result:
                        .writer(
                            post: postDetail,
                            marked: result.bookMarked,
                            participants: participants,
                            applicant: applicant,
                            roomID: result.roomID
                        )
                    )
                } else {
                    return APIResult.response(result:
                        .guest(post: postDetail,
                               participated: participants.contains(where: { $0.userID == userId }),
                               marked: result.bookMarked,
                               apply: result.isApplicant,
                               participants: participants,
                               roomID: result.roomID)
                    )
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func apply(postId: Int) -> Observable<APIResult<Bool>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.apply(postId: postId, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { try? BasicResponse(json: $0) }
            .map { response in
                guard let response = response else {
                    return APIResult.error(alertMessage: nil)
                }

                switch response.code {
                case 1000: // 성공
                    return APIResult.response(result: true)
                case 2010: // jwt와 userId 불일치
                    return APIResult.error(alertMessage: nil)
                case 2011: // userId값 필요
                    return APIResult.error(alertMessage: nil)
                case 2012: // userId 형식 오류
                    return APIResult.error(alertMessage: nil)
                case 2041: // postId 미입력
                    return APIResult.error(alertMessage: nil)
                case 2042: // postId 형식오류
                    return APIResult.error(alertMessage: nil)
                case 2044: // 인증 대기중 회원
                    return APIResult.error(alertMessage: nil)
                case 2064: // 이미 신청한 유저
                    return APIResult.error(alertMessage: nil)
                default:
                    return APIResult.error(alertMessage: nil)
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func accept(postId: Int, applicantId: Int, accept: Bool) -> Observable<APIResult<(id: Int, accept: Bool, success: Bool)>> {
        let functionResult = ReplaySubject<(id: Int, accept: Bool, success: Bool)>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.response(result: (id: applicantId, accept: accept, success: false))) }

        return provider.rx.request(
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
        .map { try? BasicResponse(json: $0) }
        .map { response in
            guard let response = response else {
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            }

            switch response.code {
            case 1000: // 성공
                return APIResult.response(result: (id: applicantId, accept: accept, success: true))
            case 2010: // jwt와 userId 불일치
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2011: // userId값 필요
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2012: // userId 형식 오류
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2041: // postId 미입력
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2042: // postId 형식오류
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2044: // 인증 대기중 회원
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2065: // applicantId 미입력
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2066: // applicantId 형식오류
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2067: // 수락 권한 없음
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2068: // accept 여부 미입력
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2069: // accept 형식 오류 "Y" "D"
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            case 2070: // applicant 유저가 모임 대기상태가 아닙니다.
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            default:
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            }
        }
        .timeout(.seconds(2), scheduler: MainScheduler.instance)
        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func close(postId: Int) -> Observable<APIResult<Bool>> {
        guard let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.close(postId: postId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { try? BasicResponse(json: $0) }
            .map { response in
                guard let response = response else {
                    return APIResult.error(alertMessage: nil)
                }

                switch response.code {
                case 1000: // 성공
                    return APIResult.response(result: true)
                case 2043:
                    return APIResult.error(alertMessage: nil)
                case 2044: // 인증 대기중 회원
                    return APIResult.error(alertMessage: nil)
                default:
                    return APIResult.error(alertMessage: nil)
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func myPage() -> Observable<APIResult<MyPageAPIResult>> {
        let functionResult = ReplaySubject<MyPageAPIResult>.create(bufferSize: 1)

        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        typealias RawDatas = (responseCode: Int?, userData: Data, postingData: Data, joinedData: Data)

        return provider.rx.request(.myPage(userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> (response: BasicResponse, json: JSON)? in
                guard let json = json
                else {
                    Log.d(tag: .network, "result: fail")
                    return nil
                }

                return try? (response: BasicResponse(json: json), json: json)
            }
            .map { result -> RawDatas? in

                let userData = (try? result?.json["result"]["myInfo"].rawData()) ?? Data()
                let postingData = (try? result?.json["result"]["myPosting"].rawData()) ?? Data()
                let joinedData = (try? result?.json["result"]["myRunning"].rawData()) ?? Data()

                Log.d(tag: .info, """
                userData:
                \(userData)
                postingData:
                \(postingData)
                joinedData:
                \(joinedData)
                """)

                return (responseCode: result?.response.code, userData: userData, postingData: postingData, joinedData: joinedData)
            }
            .compactMap { $0 }
            .map { result in
                switch result.responseCode {
                // 성공
                case 1000: // 성공, 비작성자, 참여신청O, 찜O

                    let decoder = JSONDecoder()
                    let userInfo = try? decoder.decode([User].self, from: result.userData).first
                    let posting = (try? decoder.decode([PostResponse].self, from: result.postingData)) ?? []
                    let joined = (try? decoder.decode([PostResponse].self, from: result.joinedData)) ?? []

                    let userPosting: [Post] = posting.compactMap { $0.convertedPost }
                    let userJoined: [Post] = joined.compactMap { $0.convertedPost }

                    if let user = userInfo {
                        return APIResult.response(result: .success(info: user, posting: userPosting, joined: userJoined))
                    } else {
                        return APIResult.error(alertMessage: nil)
                    }

                case 2010: // jwt와 userId 불일치
                    return APIResult.error(alertMessage: nil)
                case 2011: // userId값 필요
                    return APIResult.error(alertMessage: nil)
                case 2012: // userId 형식 오류
                    return APIResult.error(alertMessage: nil)
                case 2044: // 인증X 회원
                    return APIResult.error(alertMessage: nil)
                default:
                    return APIResult.error(alertMessage: nil)
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func attendance(postId: Int) -> Observable<APIResult<(postId: Int, success: Bool)>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.response(result: (postId: postId, success: false))) }

        return provider.rx.request(.attendance(postId: postId, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { try? BasicResponse(json: $0) }
            .map { response in
                guard let response = response else {
                    return APIResult.response(result: (postId: postId, success: false))
                }

                switch response.code {
                case 1000: // 성공
                    return APIResult.response(result: (postId: postId, success: true))
                case 2010: // jwt와 userId 불일치
                    return APIResult.response(result: (postId: postId, success: false))
                case 2011: // userId 미입력
                    return APIResult.response(result: (postId: postId, success: false))
                case 2012: // userId 형식 오류 (숫자입력 X)
                    return APIResult.response(result: (postId: postId, success: false))
                case 2041: // postId 미입력
                    return APIResult.response(result: (postId: postId, success: false))
                case 2042: // postId 형식 오류
                    return APIResult.response(result: (postId: postId, success: false))
                case 2044: // 인증 대기중 회원
                    return APIResult.response(result: (postId: postId, success: false))
                case 2077: // 유저가 해당 러닝모임에 속하지 않습니다.
                    return APIResult.response(result: (postId: postId, success: false))
                default:
                    return APIResult.response(result: (postId: postId, success: false))
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func delete(postId: Int) -> Observable<APIResult<Bool>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.delete(postId: postId, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { try? BasicResponse(json: $0) }
            .map { response in
                guard let response = response else {
                    return APIResult.error(alertMessage: nil)
                }

                switch response.code {
                case 1000: // 성공
                    return APIResult.response(result: true)
                case 2010: // jwt와 userId 불일치
                    return APIResult.error(alertMessage: nil)
                case 2011: // userId 미입력
                    return APIResult.error(alertMessage: nil)
                case 2012: // userId 형식 오류 (숫자입력 X)
                    return APIResult.error(alertMessage: nil)
                case 2041: // postId 미입력
                    return APIResult.error(alertMessage: nil)
                case 2042: // postId 형식 오류
                    return APIResult.error(alertMessage: nil)
                case 2044: // 인증 대기중 회원
                    return APIResult.error(alertMessage: nil)
                case 2077: // 유저가 해당 러닝모임에 속하지 않습니다.
                    return APIResult.error(alertMessage: nil)
                default:
                    return APIResult.error(alertMessage: nil)
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
}
