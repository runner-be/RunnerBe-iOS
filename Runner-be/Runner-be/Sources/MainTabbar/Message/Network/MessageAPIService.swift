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

enum UploadImageMessageResult {
    case succeed
    case error
}

final class MessageAPIService {
    private var disposableId: Int = 0
    private var disposableDic: [Int: DisposeBag] = [:]

    let provider: MoyaProvider<MessageAPI>
    let loginKeyChain: LoginKeyChainService

    private var imageUploadService: ImageUploadService

    init(
        provider: MoyaProvider<MessageAPI> = .init(plugins: [VerbosePlugin(verbose: true)]),
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        imageUploadService: ImageUploadService = BasicImageUploadService()

    ) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
        self.imageUploadService = imageUploadService
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

    //TODO: 역할이 3개이상 한 메서드에서 처리하는 부분을 분리시켜야할 필요가 있습니다.
    func postMessage(
        roomId: Int,
        content: [String?],
        imageData: [Data?]
    ) -> Observable<UploadImageMessageResult> {
        guard let token = loginKeyChain.token
        else {
            return .just(.error)
        }

        let functionResult = ReplaySubject<UploadImageMessageResult>.create(bufferSize: 1)
        let imageUploaded = ReplaySubject<(Int, String)>.create(bufferSize: 1)
        let disposeBag = DisposeBag()

        // 이미지 데이터가 포함되어 있으면 Firebase storage에 이미지를 업로드 합니다.
        if !imageData.isEmpty {
            imageData.enumerated().forEach { index, imageData in
                if let imageData = imageData {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
                    let uuid = UUID().uuidString
                    let uniqueFileName = "\(dateFormatter.string(from: Date()))_\(uuid).png"
                    let path = "MessageRoom/\(roomId)/\(uniqueFileName)"

                    imageUploadService.uploadImage(
                        data: imageData,
                        path: path
                    )
                    .subscribe(onNext: { url in
                        guard let url = url else {
                            functionResult.onNext(.error)
                            return
                        }
                        imageUploaded.onNext((index, url))
                    }).disposed(by: disposeBag)

                } else {
                    print("imageDat nil")
                }
            }

        } else { // 이미지 데이터가 없으면 이미지 업로드 없이 메시지전송 API를 호출합니다.
            provider.rx.request(.postMessage(
                roomId: roomId,
                postMessageRequest: PostMessageRequest(
                    content: content.first ?? ""
                ),
                token: token
            ))
            .asObservable()
            .mapResponse()
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext(.error)
                    return
                }
                switch response.basic.code {
                case 1000: // 성공
                    functionResult.onNext(.succeed)
                default:
                    functionResult.onNext(.error)
                    // FIXME: return .error(alertMessage: "오류가 발생했습니다. 다시 시도해주세요.")
                }
            }).disposed(by: disposeBag)
        }

        imageUploaded
            .map { [weak self] (index, url) in
                self?.provider.rx.request(.postMessage(
                    roomId: roomId,
                    postMessageRequest: PostMessageRequest(
                        content: content[index],
                        imageUrl: url
                    ),

                    token: token
                ))
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .mapResponse()
            .subscribe(onNext: { response in
                guard let response = response else {
                    functionResult.onNext(.error)
                    return
                }
                switch response.basic.code {
                case 1000: // 설공
                    functionResult.onNext(.succeed)
                    print("success")
                default:
                    functionResult.onNext(.error)
                }
            }).disposed(by: disposeBag)

        let id = disposableId
        disposableId += 1
        disposableDic[disposableId] = disposeBag

        return functionResult
            .do(onNext: { [weak self] _ in
                self?.disposableDic.removeValue(forKey: id)
            })
    }
}
