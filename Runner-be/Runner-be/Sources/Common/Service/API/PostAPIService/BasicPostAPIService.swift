//
//  BasicPostAPIService.swift
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
            .mapResponse()
            .compactMap { try? $0?.json["result"].rawData() }
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
            .mapResponse()
            .map { response in
                guard let response = response else {
                    Log.d(tag: .network, "result: fail")
                    return .error(alertMessage: nil)
                }

                Log.d(tag: .network, "response message: \(response.basic.message)")
                switch response.basic.code {
                case 1000: // 성공
                    return .response(result: .succeed)
                case 2010, 2011, 2012, 2044, 3006: // 유저 로그인 필요
                    return .response(result: .needLogin)
                case 2095: // 성별 불가
                    return .error(alertMessage: response.basic.message)
                case 2096:
                    // TODO: 서버의 메시지를 가져와 사용하도록
                    return .error(alertMessage: "내 성별과 다른 성별만 모집하는 글은 등록할 수 없어요.")
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
            .mapResponse()
            .map { response in
                guard let response = response else {
                    Log.d(tag: .network, "res")
                    return APIResult.response(result: (postId: postId, mark: !mark))
                }

                Log.d(tag: .network, "response message: \(response.basic.message)")
                switch response.basic.code {
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
            .mapResponse()
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
            .mapResponse()
            .map { response -> (MapResult?) in
                guard let response = response else {
                    return nil
                }

                let postData = (try? response.json["result"]["postingInfo"].rawData()) ?? Data()
                let participantData = (try? response.json["result"]["runnerInfo"].rawData()) ?? Data()
                let applicantData = (try? response.json["result"]["waitingRunnerInfo"].rawData()) ?? Data()
                let roomID = (try? response.json["result"]["roomId"].int)

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

                Log.d(tag: .network, "detailInfo(postId:\(postId)) resultCode: \(response.basic.code)")

                switch response.basic.code {
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
            .mapResponse()
            .map { response in
                guard let response = response else {
                    return APIResult.error(alertMessage: nil)
                }

                switch response.basic.code {
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
        .mapResponse()
        .map { response in
            guard let response = response else {
                return APIResult.response(result: (id: applicantId, accept: accept, success: false))
            }

            switch response.basic.code {
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
            .mapResponse()
            .map { response in
                guard let response = response else {
                    return APIResult.error(alertMessage: nil)
                }

                switch response.basic.code {
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
            .mapResponse()
            .map { response -> RawDatas? in
                guard let response = response
                else {
                    return nil
                }

                let userData = (try? response.json["result"]["myInfo"].rawData()) ?? Data()
                let postingData = (try? response.json["result"]["myPosting"].rawData()) ?? Data()
                let joinedData = (try? response.json["result"]["myRunning"].rawData()) ?? Data()

                Log.d(tag: .info, """
                userData:
                \(userData)
                postingData:
                \(postingData)
                joinedData:
                \(joinedData)
                """)

                return (
                    responseCode: response.basic.code,
                    userData: userData,
                    postingData: postingData,
                    joinedData: joinedData
                ) as RawDatas
            }
            .compactMap { $0 }
            .map { result in
                switch result.responseCode {
                // 성공
                case 1000: // 성공, 비작성자, 참여신청O, 찜O

                    let decoder = JSONDecoder()
                    let userInfo = try? decoder.decode(User.self, from: result.userData)
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

    func getRunnerList() -> Observable<APIResult<[MyPosting]?>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.getRunnerList(userId: userId, token: token))
            .asObservable()
            .mapResponse()
            .compactMap { (try? $0?.json["result"]["myPosting"].rawData()) ?? Data() }
            .decode(type: [MyPosting]?.self, decoder: JSONDecoder())
            .catch { error in
                Log.e("\(error)")
                return .just(nil)
            } // 에러발생시 nil observable return
            .map { APIResult.response(result: $0?.sorted(by: { $0.gatheringTime! > $1.gatheringTime! })) }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func mangageAttendance(postId: Int, request: PatchAttendanceRequest) -> Observable<APIResult<Bool>> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error(alertMessage: nil))
        }

        return provider.rx.request(.manageAttendance(
            postId: postId,
            request: request,
            token: token
        ))
        .asObservable()
        .mapResponse()
        .catch { error in
            Log.e("\(error)")
            return .just(nil)
        } // 에러발생시 nil observable return
        .map { APIResult.response(result: $0?.basic.isSuccess ?? false) }
        .timeout(.seconds(2), scheduler: MainScheduler.instance)
        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요")) // error 발생시 error observable return
    }

    func attendance(postId: Int) -> Observable<APIResult<(postId: Int, success: Bool)>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.response(result: (postId: postId, success: false))) }

        return provider.rx.request(.attendance(postId: postId, userId: userId, token: token))
            .asObservable()
            .mapResponse()
            .map { response in
                guard let response = response else {
                    return APIResult.response(result: (postId: postId, success: false))
                }

                switch response.basic.code {
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
            .mapResponse()
            .map { response in
                guard let response = response else {
                    return APIResult.error(alertMessage: nil)
                }

                switch response.basic.code {
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

    func report(postId: Int) -> Observable<APIResult<Bool>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.report(postId: postId, userId: userId, token: token))
            .asObservable()
            .mapResponse()
            .map { response in
                guard let response = response else {
                    return APIResult.error(alertMessage: nil)
                }

                switch response.basic.code {
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
                case 2045: // 존재하지 않는 postId
                    return APIResult.error(alertMessage: nil)
                default:
                    return APIResult.error(alertMessage: nil)
                }
            }
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    // 해당 postId의 모임의 참여자 목록 가져옵니다.
    // 출석 관련 API가 존재하지 않아 게시글상세보기 API를 통해 데이터를 가져옵니다.
    // 이 후 출석 관련 API가 추가되면 아래코드는 수정 또는 삭제가 필요합니다.
    func attendanceList(postId: Int) -> Observable<APIResult<[RunnerInfo]>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.detail(
            postId: postId,
            userId: userId,
            token: token
        ))
        .asObservable()
        .mapResponse()
        .map { response in
            guard let response = response else {
                return .error(alertMessage: "Invalid response")
            }

            let runnerInfoData = (try? response.json["result"]["runnerInfo"].rawData()) ?? Data()

            Log.d(tag: .info, "runnerInfo : \(runnerInfoData)")

            switch response.basic.code {
            case 1015, 1016, 1017, 1018, 1019, 1020:
                // 성공 코드이므로 데이터를 반환해야 함
                let decoder = JSONDecoder()
                if let runnerInfo = try? decoder.decode([RunnerInfo].self, from: runnerInfoData) {
                    return .response(result: runnerInfo)
                } else {
                    return .error(alertMessage: "Data parsing failed")
                }

            case 2010, 2011, 2012, 2041, 2042, 2044, 4000:
                return .error(alertMessage: "API error: \(response.basic.message)")
            default:
                return .error(alertMessage: "Unknown error")
            }
        }
        .timeout(.seconds(2), scheduler: MainScheduler.instance)
        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func manageAttendacne(postId: Int) -> Observable<APIResult<ManageAttendance>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else { return .just(APIResult.error(alertMessage: nil)) }

        return provider.rx.request(.detail(
            postId: postId,
            userId: userId,
            token: token
        ))
        .asObservable()
        .mapResponse()
        .map { response in
            guard let response = response else {
                return .error(alertMessage: "Invalid response")
            }
            let postData = (try? response.json["result"]["postingInfo"].rawData()) ?? Data()
            let runnerInfoData = (try? response.json["result"]["runnerInfo"].rawData()) ?? Data()

            Log.d(tag: .info, "runnerInfo : \(runnerInfoData)")

            switch response.basic.code {
            case 1015, 1016, 1017, 1018, 1019, 1020:
                // 성공 코드이므로 데이터를 반환해야 함
                let decoder = JSONDecoder()
                if let detailPosts = try? decoder.decode([DetailPostResponse].self, from: postData),
                   let detailPost = detailPosts.first?.convertedDetailPost,
                   let runnerInfo = try? decoder.decode([RunnerInfo].self, from: runnerInfoData)
                {
//                    let runnerInfo = runnerInfo
                    // 출석 마감 상태 (출석확인) : (러닝모임 시간 + 러닝타임 + 출석관리시간 3시간(고정))
                    // 출석 관리 상태 : (러닝모임 시간 + 러닝타임)

                    return .response(result: ManageAttendance(
                        currentDate: Date(),
                        gatherDate: detailPost.post.gatherDate,
                        runningTime: detailPost.post.runningTime,
                        attendanceList: runnerInfo
                    ))
                } else {
                    return .error(alertMessage: "Data parsing failed")
                }

            case 2010, 2011, 2012, 2041, 2042, 2044, 4000:
                return .error(alertMessage: "API error: \(response.basic.message)")
            default:
                return .error(alertMessage: "Unknown error")
            }
        }
        .timeout(.seconds(2), scheduler: MainScheduler.instance)
        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }
}
