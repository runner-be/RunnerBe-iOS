//
//  BasicUserAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/28.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicUserAPIService: UserAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: DisposeBag] = [:]

    private var imageUploadService: ImageUploadService
    private var loginKeyChainService: LoginKeyChainService
    private var provider: MoyaProvider<UserAPI>

    init(
        provider: MoyaProvider<UserAPI> = .init(plugins: [VerbosePlugin(verbose: true)]),
        loginKeyChainService: LoginKeyChainService,
        imageUploadService: ImageUploadService
    ) {
        self.provider = provider
        self.loginKeyChainService = loginKeyChainService
        self.imageUploadService = imageUploadService
    }

    func setNickName(to nickName: String) -> Observable<SetNickNameResult> {
        let functionResult = ReplaySubject<SetNickNameResult>.create(bufferSize: 1)
        let disposeBag = DisposeBag()
        #if DEBUG
            print("[\(#line)BasieUserAPI:\(#function)]: nickName: \(nickName)")
        #endif

        guard let userId = loginKeyChainService.userId,
              let token = loginKeyChainService.token
        else {
            return .just(.error)
        }

        provider.rx.request(.editNickName(toName: nickName, userId: userId, token: token))
            .asObservable()
            .map { try? JSON(data: $0.data) }
            .map { json -> BasicResponse? in
                #if DEBUG
                    print("[\(#line)BasieUserAPI:\(#function)]: nickName: \(nickName)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result == nil")
                    #endif
                    functionResult.onNext(.error)
                    return nil
                }
                #if DEBUG
                    print("result: \n\(json)")
                #endif
                return try? BasicResponse(json: json)
            }
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext(.error)
                    return
                }
                #if DEBUG
                    print("response Message: \(response.message)")
                #endif
                switch response.code {
                case 1000: // 성공
                    functionResult.onNext(.succeed(name: nickName))
                case 2010: // jwt와 userID 불일치
                    functionResult.onNext(.error)
                case 2011: // userId 미입력
                    functionResult.onNext(.error)
                case 2012: // userId 형식 오류
                    functionResult.onNext(.error)
                case 2013: // 닉네임 미입력
                    functionResult.onNext(.error)
                case 2044: // 인증 대기중 회원
                    functionResult.onNext(.error)
                case 3004: // 중복된 닉네임
                    functionResult.onNext(.duplicated)
                case 3005: // 이미 변경이력 있음
                    functionResult.onNext(.alreadyChanged)
                case 4000: // 데이터 베이스 에러
                    functionResult.onNext(.error)
                default:
                    functionResult.onNext(.error)
                }
            })
            .disposed(by: disposeBag)

        let id = disposableId
        disposableId += 1
        disposableDic[disposableId] = disposeBag

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposableDic.removeValue(forKey: id)
            })
    }

    func setJob(to _: Job) -> Observable<SetJobResult> {
        return .just(.succeed)
    }

    func setProfileImage(to data: Data) -> Observable<SetProfileResult> {
        guard let userId = loginKeyChainService.userId,
              let token = loginKeyChainService.token
        else {
            return .just(.error)
        }

        let functionResult = ReplaySubject<SetProfileResult>.create(bufferSize: 1)
        let imageUploaded = ReplaySubject<String>.create(bufferSize: 1)
        let disposeBag = DisposeBag()

        let path = "UserProfile/\(userId).png"

        imageUploadService.uploadImage(data: data, path: path)
            .subscribe(onNext: { url in
                guard let url = url
                else {
                    functionResult.onNext(.error)
                    return
                }
                print("[\(#line)BasieUserAPI:\(#function)]: imageURL: \(url)")
                imageUploaded.onNext(url)
            })
            .disposed(by: disposeBag)

        imageUploaded
            .map { [weak self] url in
                self?.provider.rx.request(
                    .setProfile(profileURL: url, userId: userId, token: token)
                )
            }
            .do(onNext: {
                if $0 == nil { functionResult.onNext(.error) }
            })
            .compactMap { $0 }
            .flatMap { $0 }
            .map { try? JSON(data: $0.data) }
            .map { json -> BasicResponse? in
                #if DEBUG
                    print("[\(#line)BasieUserAPI:\(#function)]: userID: \(userId)")
                #endif
                guard let json = json
                else {
                    #if DEBUG
                        print("result == nil")
                    #endif
                    functionResult.onNext(.error)
                    return nil
                }
                #if DEBUG
                    print("result: \n\(json)")
                #endif
                return try? BasicResponse(json: json)
            }
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext(.error)
                    return
                }
                #if DEBUG
                    print("response Message: \(response.message)")
                #endif
                switch response.code {
                case 1000: // 성공
                    functionResult.onNext(.succeed(data: data))
                case 2010: // jwt와 userID 불일치
                    functionResult.onNext(.error)
                case 2011: // userId 미입력
                    functionResult.onNext(.error)
                case 2012: // userId 형식 오류
                    functionResult.onNext(.error)
                case 2044: // 인증 대기중 회원
                    functionResult.onNext(.error)
                case 4000: // 데이터 베이스 에러
                    functionResult.onNext(.error)
                default:
                    functionResult.onNext(.error)
                }
            })
            .disposed(by: disposeBag)

        let id = disposableId
        disposableId += 1
        disposableDic[disposableId] = disposeBag

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposableDic.removeValue(forKey: id)
            })
    }
}
