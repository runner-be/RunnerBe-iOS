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

final class MessageAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]

    let provider: MoyaProvider<MessageAPI>
    let loginKeyChain: LoginKeyChainService

    init(provider: MoyaProvider<MessageAPI> = .init(plugins: [VerbosePlugin(verbose: true)]), loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
    }

    func getMessageList() -> Observable<APIResult<[MessageListItem]?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getMessageList(token: token))
            .asObservable() // return type을 observable로
            .mapResponse()
            .map { (try? $0?.json["result"].rawData()) ?? Data() } // result에 해당하는 rawData
            .decode(type: [MessageListItem]?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0 ?? []) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }

    func getMessages(roomId: Int) -> Observable<APIResult<GetMessageChatResult?>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.getMessages(roomId: roomId, token: token))
            .asObservable() // return type을 observable로
            .mapResponse()
            .map { (try? $0?.json["result"].rawData()) ?? Data() } // result에 해당하는 rawData
            .decode(type: GetMessageChatResult?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }
    
    func postMessage(roomId: Int, content:String) -> Observable<APIResult<Bool>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.postMessage(roomId: roomId, postMessageRequest: PostMessageRequest(content:content), token: token))
            .asObservable()
            .mapResponse()
            .map { response in
                guard let response = response else {
                    Log.d(tag: .network, "res")
                    return APIResult.error(alertMessage: nil)
                }

                Log.d(tag: .network, "response message: \(response.basic.message)")
                switch response.basic.code {
                case 1000: // 성공
                    return APIResult.response(result: true)
                default:
                    return APIResult.error(alertMessage: "오류가 발생했습니다. 다시 시도해주세요")
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
    
//    func posting(form: PostingForm) -> Observable<APIResult<PostingResult>> {
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else {
//            return .just(APIResult.response(result: .needLogin))
//        }
//
//        return provider.rx.request(.posting(form: form, id: userId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response in
//                guard let response = response else {
//                    Log.d(tag: .network, "result: fail")
//                    return .error(alertMessage: nil)
//                }
//
//                Log.d(tag: .network, "response message: \(response.basic.message)")
//                switch response.basic.code {
//                case 1000: // 성공
//                    return .response(result: .succeed)
//                case 2010, 2011, 2012, 2044, 3006: // 유저 로그인 필요
//                    return .response(result: .needLogin)
//                case 2095: // 성별 불가
//                    return .error(alertMessage: response.basic.message)
//                case 4000: // db에러
//                    return .error(alertMessage: nil)
//                default: // 나머지 에러
//                    return .error(alertMessage: nil)
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//

//
//    func detailInfo(postId: Int) -> Observable<APIResult<DetailInfoResult>> {
//        typealias MapResult = (
//            bookMarked: Bool,
//            isWriter: Bool,
//            isApplicant: Bool,
//            post: Data,
//            participants: Data,
//            applicant: Data,
//            roomID: Int?
//        )
//
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else { return .just(APIResult.error(alertMessage: nil)) }
//
//        return provider.rx.request(.detail(postId: postId, userId: userId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response -> (MapResult?) in
//                guard let response = response else {
//                    return nil
//                }
//
//                let postData = (try? response.json["result"]["postingInfo"].rawData()) ?? Data()
//                let participantData = (try? response.json["result"]["runnerInfo"].rawData()) ?? Data()
//                let applicantData = (try? response.json["result"]["waitingRunnerInfo"].rawData()) ?? Data()
//                let roomID = (try? response.json["result"]["roomId"].int)
//
//                Log.d(tag: .info, """
//                postData :
//                \(postData)
//                participantData :
//                \(participantData)
//                applicantData :
//                \(applicantData)
//                """)
//
//                var bookMarked = false
//                var writer = false
//                var applicant = false
//
//                Log.d(tag: .network, "detailInfo(postId:\(postId)) resultCode: \(response.basic.code)")
//
//                switch response.basic.code {
//                // 성공
//                case 1015: // 성공, 비작성자, 참여신청O, 찜O
//                    bookMarked = true
//                    applicant = true
//                case 1016: // 성공, 비작성자, 참여신청O, 찜X
//                    applicant = true
//                case 1017: // 성공, 비작성자, 참여신청X, 찜O
//                    bookMarked = true
//                case 1018: // 성공, 비작성자, 참여신청X, 찜X
//                    break
//                case 1019: // 성공, 작성자, 찜O
//                    writer = true
//                    bookMarked = true
//                case 1020: // 성공, 작성자, 찜X
//                    writer = true
//                // 실패
//                case 2010: // jwt와 userId 불일치
//                    return nil
//                case 2011: // userId값 필요
//                    return nil
//                case 2012: // userId 형식 오류
//                    return nil
//                case 2041: // postId 미입력
//                    return nil
//                case 2042: // postId 형식오류
//                    return nil
//                case 2044: // 인증X 회원
//                    return nil
//                case 4000: // 데이터베이스 에러
//                    return nil
//                default:
//                    return nil
//                }
//
//                return MapResult(
//                    bookMarked: bookMarked,
//                    isWriter: writer,
//                    isApplicant: applicant,
//                    post: postData,
//                    participants: participantData,
//                    applicant: applicantData,
//                    roomID: roomID
//                )
//            }
//            .compactMap { $0 }
//            .map { result in
//                let decoder = JSONDecoder()
//                let posts = try? decoder.decode([DetailPostResponse].self, from: result.post)
//                let participants = (try? decoder.decode([UserResponse].self, from: result.participants))?.map { $0.userInfo } ?? []
//                let applicant = (try? decoder.decode([UserResponse].self, from: result.applicant))?.map { $0.userInfo } ?? []
//
//                guard let postDetail = posts?.first?.convertedDetailPost
//                else {
//                    return APIResult.error(alertMessage: nil)
//                }
//
//                if result.isWriter {
//                    return APIResult.response(result:
//                        .writer(
//                            post: postDetail,
//                            marked: result.bookMarked,
//                            participants: participants,
//                            applicant: applicant,
//                            roomID: result.roomID
//                        )
//                    )
//                } else {
//                    return APIResult.response(result:
//                        .guest(post: postDetail,
//                               participated: participants.contains(where: { $0.userID == userId }),
//                               marked: result.bookMarked,
//                               apply: result.isApplicant,
//                               participants: participants,
//                               roomID: result.roomID)
//                    )
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//
//    func apply(postId: Int) -> Observable<APIResult<Bool>> {
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else { return .just(APIResult.error(alertMessage: nil)) }
//
//        return provider.rx.request(.apply(postId: postId, userId: userId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response in
//                guard let response = response else {
//                    return APIResult.error(alertMessage: nil)
//                }
//
//                switch response.basic.code {
//                case 1000: // 성공
//                    return APIResult.response(result: true)
//                case 2010: // jwt와 userId 불일치
//                    return APIResult.error(alertMessage: nil)
//                case 2011: // userId값 필요
//                    return APIResult.error(alertMessage: nil)
//                case 2012: // userId 형식 오류
//                    return APIResult.error(alertMessage: nil)
//                case 2041: // postId 미입력
//                    return APIResult.error(alertMessage: nil)
//                case 2042: // postId 형식오류
//                    return APIResult.error(alertMessage: nil)
//                case 2044: // 인증 대기중 회원
//                    return APIResult.error(alertMessage: nil)
//                case 2064: // 이미 신청한 유저
//                    return APIResult.error(alertMessage: nil)
//                default:
//                    return APIResult.error(alertMessage: nil)
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//
//    func accept(postId: Int, applicantId: Int, accept: Bool) -> Observable<APIResult<(id: Int, accept: Bool, success: Bool)>> {
//        let functionResult = ReplaySubject<(id: Int, accept: Bool, success: Bool)>.create(bufferSize: 1)
//
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else { return .just(APIResult.response(result: (id: applicantId, accept: accept, success: false))) }
//
//        return provider.rx.request(
//            .accept(
//                postId: postId,
//                userId: userId,
//                applicantId: applicantId,
//                accept: accept,
//                token: token
//            )
//        )
//        .asObservable()
//        .mapResponse()
//        .map { response in
//            guard let response = response else {
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            }
//
//            switch response.basic.code {
//            case 1000: // 성공
//                return APIResult.response(result: (id: applicantId, accept: accept, success: true))
//            case 2010: // jwt와 userId 불일치
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2011: // userId값 필요
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2012: // userId 형식 오류
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2041: // postId 미입력
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2042: // postId 형식오류
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2044: // 인증 대기중 회원
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2065: // applicantId 미입력
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2066: // applicantId 형식오류
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2067: // 수락 권한 없음
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2068: // accept 여부 미입력
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2069: // accept 형식 오류 "Y" "D"
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            case 2070: // applicant 유저가 모임 대기상태가 아닙니다.
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            default:
//                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
//            }
//        }
//        .timeout(.seconds(2), scheduler: MainScheduler.instance)
//        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//
//    func close(postId: Int) -> Observable<APIResult<Bool>> {
//        guard let token = loginKeyChain.token
//        else { return .just(APIResult.error(alertMessage: nil)) }
//
//        return provider.rx.request(.close(postId: postId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response in
//                guard let response = response else {
//                    return APIResult.error(alertMessage: nil)
//                }
//
//                switch response.basic.code {
//                case 1000: // 성공
//                    return APIResult.response(result: true)
//                case 2043:
//                    return APIResult.error(alertMessage: nil)
//                case 2044: // 인증 대기중 회원
//                    return APIResult.error(alertMessage: nil)
//                default:
//                    return APIResult.error(alertMessage: nil)
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//
//    func myPage() -> Observable<APIResult<MyPageAPIResult>> {
//        let functionResult = ReplaySubject<MyPageAPIResult>.create(bufferSize: 1)
//
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else { return .just(APIResult.error(alertMessage: nil)) }
//
//        typealias RawDatas = (responseCode: Int?, userData: Data, postingData: Data, joinedData: Data)
//
//        return provider.rx.request(.myPage(userId: userId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response -> RawDatas? in
//                guard let response = response
//                else {
//                    return nil
//                }
//
//                let userData = (try? response.json["result"]["myInfo"].rawData()) ?? Data()
//                let postingData = (try? response.json["result"]["myPosting"].rawData()) ?? Data()
//                let joinedData = (try? response.json["result"]["myRunning"].rawData()) ?? Data()
//
//                Log.d(tag: .info, """
//                userData:
//                \(userData)
//                postingData:
//                \(postingData)
//                joinedData:
//                \(joinedData)
//                """)
//
//                return (responseCode: response.basic.code, userData: userData, postingData: postingData, joinedData: joinedData)
//            }
//            .compactMap { $0 }
//            .map { result in
//                switch result.responseCode {
//                // 성공
//                case 1000: // 성공, 비작성자, 참여신청O, 찜O
//
//                    let decoder = JSONDecoder()
//                    let userInfo = try? decoder.decode(User.self, from: result.userData)
//                    let posting = (try? decoder.decode([PostResponse].self, from: result.postingData)) ?? []
//                    let joined = (try? decoder.decode([PostResponse].self, from: result.joinedData)) ?? []
//
//                    let userPosting: [Post] = posting.compactMap { $0.convertedPost }
//                    let userJoined: [Post] = joined.compactMap { $0.convertedPost }
//
//                    if let user = userInfo {
//                        return APIResult.response(result: .success(info: user, posting: userPosting, joined: userJoined))
//                    } else {
//                        return APIResult.error(alertMessage: nil)
//                    }
//
//                case 2010: // jwt와 userId 불일치
//                    return APIResult.error(alertMessage: nil)
//                case 2011: // userId값 필요
//                    return APIResult.error(alertMessage: nil)
//                case 2012: // userId 형식 오류
//                    return APIResult.error(alertMessage: nil)
//                case 2044: // 인증X 회원
//                    return APIResult.error(alertMessage: nil)
//                default:
//                    return APIResult.error(alertMessage: nil)
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//
//    func attendance(postId: Int) -> Observable<APIResult<(postId: Int, success: Bool)>> {
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else { return .just(APIResult.response(result: (postId: postId, success: false))) }
//
//        return provider.rx.request(.attendance(postId: postId, userId: userId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response in
//                guard let response = response else {
//                    return APIResult.response(result: (postId: postId, success: false))
//                }
//
//                switch response.basic.code {
//                case 1000: // 성공
//                    return APIResult.response(result: (postId: postId, success: true))
//                case 2010: // jwt와 userId 불일치
//                    return APIResult.response(result: (postId: postId, success: false))
//                case 2011: // userId 미입력
//                    return APIResult.response(result: (postId: postId, success: false))
//                case 2012: // userId 형식 오류 (숫자입력 X)
//                    return APIResult.response(result: (postId: postId, success: false))
//                case 2041: // postId 미입력
//                    return APIResult.response(result: (postId: postId, success: false))
//                case 2042: // postId 형식 오류
//                    return APIResult.response(result: (postId: postId, success: false))
//                case 2044: // 인증 대기중 회원
//                    return APIResult.response(result: (postId: postId, success: false))
//                case 2077: // 유저가 해당 러닝모임에 속하지 않습니다.
//                    return APIResult.response(result: (postId: postId, success: false))
//                default:
//                    return APIResult.response(result: (postId: postId, success: false))
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//
//    func delete(postId: Int) -> Observable<APIResult<Bool>> {
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else { return .just(APIResult.error(alertMessage: nil)) }
//
//        return provider.rx.request(.delete(postId: postId, userId: userId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response in
//                guard let response = response else {
//                    return APIResult.error(alertMessage: nil)
//                }
//
//                switch response.basic.code {
//                case 1000: // 성공
//                    return APIResult.response(result: true)
//                case 2010: // jwt와 userId 불일치
//                    return APIResult.error(alertMessage: nil)
//                case 2011: // userId 미입력
//                    return APIResult.error(alertMessage: nil)
//                case 2012: // userId 형식 오류 (숫자입력 X)
//                    return APIResult.error(alertMessage: nil)
//                case 2041: // postId 미입력
//                    return APIResult.error(alertMessage: nil)
//                case 2042: // postId 형식 오류
//                    return APIResult.error(alertMessage: nil)
//                case 2044: // 인증 대기중 회원
//                    return APIResult.error(alertMessage: nil)
//                case 2077: // 유저가 해당 러닝모임에 속하지 않습니다.
//                    return APIResult.error(alertMessage: nil)
//                default:
//                    return APIResult.error(alertMessage: nil)
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
//
//    func report(postId: Int) -> Observable<APIResult<Bool>> {
//        guard let userId = loginKeyChain.userId,
//              let token = loginKeyChain.token
//        else { return .just(APIResult.error(alertMessage: nil)) }
//
//        return provider.rx.request(.report(postId: postId, userId: userId, token: token))
//            .asObservable()
//            .mapResponse()
//            .map { response in
//                guard let response = response else {
//                    return APIResult.error(alertMessage: nil)
//                }
//
//                switch response.basic.code {
//                case 1000: // 성공
//                    return APIResult.response(result: true)
//                case 2010: // jwt와 userId 불일치
//                    return APIResult.error(alertMessage: nil)
//                case 2011: // userId 미입력
//                    return APIResult.error(alertMessage: nil)
//                case 2012: // userId 형식 오류 (숫자입력 X)
//                    return APIResult.error(alertMessage: nil)
//                case 2041: // postId 미입력
//                    return APIResult.error(alertMessage: nil)
//                case 2042: // postId 형식 오류
//                    return APIResult.error(alertMessage: nil)
//                case 2044: // 인증 대기중 회원
//                    return APIResult.error(alertMessage: nil)
//                case 2045: // 존재하지 않는 postId
//                    return APIResult.error(alertMessage: nil)
//                default:
//                    return APIResult.error(alertMessage: nil)
//                }
//            }
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
//            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
//    }
}
