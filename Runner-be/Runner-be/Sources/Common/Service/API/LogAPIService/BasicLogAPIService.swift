//
//  BasicLogAPIService.swift
//  Runner-be
//
//  Created by 김창규 on 9/4/24.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

final class BasicLogAPIService: LogAPIService {
    // MARK: - Properties

    private var disposabledId: Int = 0
    private var disposableDic: [Int: Disposable] = [:]
    private let disposeBag = DisposeBag() // FIXME: 임시

    let provider: MoyaProvider<LogAPI>
    let loginKeyChain: LoginKeyChainService
    private var imageUploadService: ImageUploadService

    // MARK: - Init

    init(
        provider: MoyaProvider<LogAPI> = .init(plugins: [VerbosePlugin(verbose: true)]),

        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        imageUploadService: ImageUploadService = BasicImageUploadService()
    ) {
        loginKeyChain = loginKeyChainService
        self.provider = provider
        self.imageUploadService = imageUploadService
    }

    // MARK: - Methods

    func fetchLog(
        year: String,
        month: String
    ) -> Observable<APIResult<(year: String, month: String)>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(APIResult.response(result: (year: year, month: month)))
        }
        return provider.rx.request(.fetchLog(
            userId: userId,
            year: year,
            month: month,
            token: token
        ))
        .asObservable()
        .mapResponse()
        .map { response in
            guard let response = response else {
                Log.d(tag: .network, "res")
                return APIResult.response(result: (year: year, month: month))
            }

            Log.d(tag: .network, "response message: \(response.basic.message)")
            switch response.basic.code {
            case 1000: // 성공
                return APIResult.response(result: (year: year, month: month))
            case 2010: // jwt의 userId와 userId가 일치하지 않습니다.
                return APIResult.response(result: (year: year, month: month))
            case 2115: // 연도를 입력해 주세요.
                return APIResult.response(result: (year: year, month: month))
            case 2116: // 월 단위를 입력해 주세요.
                return APIResult.response(result: (year: year, month: month))
            default:
                return APIResult.response(result: (year: year, month: month))
            }
        }
        .timeout(.seconds(2), scheduler: MainScheduler.instance)
        .catchAndReturn(.error(alertMessage: "네트워크 연결을 다시 확인해 주세요"))
    }

    func fetchStamp() {}

    func create(form: LogForm) -> Observable<APIResult<LogResult>> {
        guard let userId = loginKeyChain.userId,
              let token = loginKeyChain.token
        else {
            return .just(APIResult.response(result: LogResult.fail))
        }

        let functionResult = ReplaySubject<APIResult<LogResult>>.create(bufferSize: 1)
        let imageUploaded = ReplaySubject<String>.create(bufferSize: 1)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let uuid = UUID().uuidString
        let uniqueFileName = "\(dateFormatter.string(from: Date()))_\(uuid).png"
        let path = "RunningLogs/\(form.gatheringId ?? 0)/\(uniqueFileName)"

        // 이미지 데이터가 존재하면 이미지 업로드를 시도합니다.
        if let imageData = form.imageData {
            imageUploadService.uploadImage(
                data: imageData,
                path: path
            ).subscribe(onNext: { url in
                guard let url = url else {
                    functionResult.onNext(APIResult.response(result: LogResult.fail))
                    return
                }
                imageUploaded.onNext(url)
            }).disposed(by: disposeBag)
        } else {
            provider.rx.request(.create(
                createLogRequest: form,
                userId: userId,
                token: token
            ))
            .asObservable()
            .mapResponse()
            .subscribe(onNext: { response in
                guard let response = response else {
                    Log.d(tag: .network, "res")
                    functionResult.onNext(APIResult.response(result: LogResult.fail))
                    return
                }

                Log.d(tag: .network, "response message: \(response.basic.message)")
                switch response.basic.code {
                case 1000: // 성공
                    return functionResult.onNext(APIResult.response(result: LogResult.succeed))
                case 2010: // jwt의 userId와 userId가 일치하지 않습니다.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2011: // userId 값을 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2109: // 러닝로그 날짜를 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2110: // 러닝 스탬프 코드를 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2111: // 러닝 날씨 기온을 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2026: // 자유 내용은 500자 이내로 입력해줴요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2112: // 러닝 날짜는 YYYY-MM-DD 형태로 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                default:
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                }
            }).disposed(by: disposeBag)
        }

        imageUploaded
            .map { [weak self] uploadedURL in
                self?.provider.rx.request(.create(
                    createLogRequest: LogForm(
                        runningDate: form.runningDate,
                        gatheringId: form.gatheringId,
                        stampCode: form.stampCode,
                        contents: form.contents,
                        imageUrl: uploadedURL,
                        imageData: form.imageData,
                        weatherDegree: form.weatherDegree,
                        weatherIcon: form.weatherIcon,
                        isOpened: form.isOpened
                    ),
                    userId: userId,
                    token: token
                ))
            }
            .compactMap { $0 }
            .flatMap { $0 }
            .mapResponse()
            .subscribe(onNext: { response in
                guard let response = response else {
                    Log.d(tag: .network, "res")
                    functionResult.onNext(APIResult.response(result: LogResult.fail))
                    return
                }

                Log.d(tag: .network, "response message: \(response.basic.message)")
                switch response.basic.code {
                case 1000: // 성공
                    return functionResult.onNext(APIResult.response(result: LogResult.succeed))
                case 2010: // jwt의 userId와 userId가 일치하지 않습니다.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2011: // userId 값을 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2109: // 러닝로그 날짜를 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2110: // 러닝 스탬프 코드를 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2111: // 러닝 날씨 기온을 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2026: // 자유 내용은 500자 이내로 입력해줴요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                case 2112: // 러닝 날짜는 YYYY-MM-DD 형태로 입력해주세요.
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                default:
                    return functionResult.onNext(APIResult.response(result: LogResult.fail))
                }
            }).disposed(by: disposeBag)

        return functionResult
    }

    func eidt() {}

    func delete() {}

    func detail() {}
}
