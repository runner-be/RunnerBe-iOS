//
//  WriteLogViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import RxSwift

enum WriteLogMode {
    case create
    case edit
}

final class WriteLogViewModel: BaseViewModel {
    // MARK: - Properties

    // 로그 작성/수정 구별
    private let writeLogMode: WriteLogMode

    struct Input {
        var showLogStampBottomSheet = PublishSubject<Void>()
        var tapPhotoButton = PublishSubject<Void>()
        var tapPhotoCancel = PublishSubject<Void>()
        var tapWeather = PublishSubject<Void>()
        var tapTogether = PublishSubject<Void>()
        var photoSelected = PublishSubject<Data?>()
        var createLog = PublishSubject<Void>()
        var contents = PublishSubject<String?>()
        var isPrivacyOn = PublishSubject<Int>()
    }

    struct Output {
        var initialLogForm = ReplaySubject<LogForm>.create(bufferSize: 1)
        var selectedLogStamp = PublishSubject<StampType>()
        var selectedWeather = PublishSubject<(StampType, String)>()
        var showPicker = PublishSubject<EditProfileType>()
        var selectedImageChanged = PublishSubject<Data?>()
        var logDate = ReplaySubject<String>.create(bufferSize: 1)
        var logPartners = PublishSubject<([LogPartners], Int?)>()
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var logStampBottomSheet = PublishSubject<(
            stampType: StampType,
            title: String,
            gatheringId: Int?
        )>()
        var stampBottomSheet = PublishSubject<(stamp: StampType, temp: String)>()
        var togetherRunner = PublishSubject<(logId: Int, gatheringId: Int)>()
        var photoModal = PublishSubject<Void>()
        var backwardModal = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = ReplaySubject<Bool>.create(bufferSize: 1)
        var selectedLogStamp = PublishSubject<StampType>()
        var selectedWeather = PublishSubject<(stamp: StampType, temp: String)>()
        var photoTypeSelected = PublishSubject<EditProfileType?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    var selectedLogStamp: StampType?
    var weatherStamp: StampType?
    var weatherTemp: String?
    var logForm: LogForm

    // MARK: - Init

    init(
        logAPIService: LogAPIService = BasicLogAPIService(),
        logForm: LogForm,
        writeLogMode: WriteLogMode
    ) {
        self.logForm = logForm
        self.writeLogMode = writeLogMode
        super.init()

        // ++ 초기 설정
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        let formattedDate = dateFormatter.string(from: logForm.runningDate)
        outputs.logDate.onNext(formattedDate)
        outputs.initialLogForm.onNext(logForm)
        selectedLogStamp = StampType(rawValue: logForm.stampCode ?? "")
        // -- 초기 설정

        if let gatheringId = logForm.gatheringId {
            logAPIService.partners(gatheringId: gatheringId)
                .compactMap { [weak self] result in
                    switch result {
                    case let .response(data):
                        if let data = data {
                            return (data, gatheringId)
                        }
                        self?.toast.onNext("함께한 러너 프로필 조회에 실패했습니다.")
                    case let .error(alertMessage):
                        if let alertMessage = alertMessage {
                            self?.toast.onNext(alertMessage)
                        }
                        return nil
                    }
                    return nil
                }
                .bind(to: outputs.logPartners)
                .disposed(by: disposeBag)
        }
        inputs.showLogStampBottomSheet
            .compactMap { [weak self] _ in
                if let selectedLogStamp = self?.selectedLogStamp {
                    return (
                        stampType: selectedLogStamp,
                        title: "스탬프",
                        gatheringId: logForm.gatheringId
                    )
                } else {
                    return (
                        stampType: StampType(rawValue: "RUN001")!,
                        title: "스탬프",
                        gatheringId: logForm.gatheringId
                    )
                }
            }
            .bind(to: routes.logStampBottomSheet)
            .disposed(by: disposeBag)

        inputs.contents
            .bind { [weak self] contents in
                self?.logForm.contents = contents
            }.disposed(by: disposeBag)

        inputs.tapPhotoButton
            .bind(to: routes.photoModal)
            .disposed(by: disposeBag)

        inputs.tapPhotoCancel
            .bind { [weak self] _ in
                self?.logForm.imageUrl = ""
                self?.outputs.selectedImageChanged.onNext(nil)
            }
            .disposed(by: disposeBag)

        inputs.tapWeather
            .compactMap { [weak self] _ in
                guard let selectedStamp = self?.weatherStamp,
                      let selectedTemp = self?.weatherTemp
                else { // FIXME: - 하드코딩
                    return (stamp: StampType(rawValue: "WEA001")!, temp: "")
                }
                return (stamp: selectedStamp, temp: selectedTemp)
            }
            .bind(to: routes.stampBottomSheet)
            .disposed(by: disposeBag)

        inputs.tapTogether
            .compactMap { [weak self] _ in
                guard let self = self,
                      let logId = logForm.logId,
                      let gatheringId = logForm.gatheringId
                else {
                    return nil
                }
                return (logId, gatheringId)
            }
            .bind(to: routes.togetherRunner)
            .disposed(by: disposeBag)

        inputs.photoSelected
            .do(onNext: { [weak self] _ in
                self?.toastActivity.onNext(true)
            })
            .compactMap { [weak self] data in
                if data == nil {
                    self?.toastActivity.onNext(false)
                    self?.toast.onNext("이미지 불러오기에 실패했어요")
                }
                self?.logForm.imageData = data
                return data
            }
            .bind(to: outputs.selectedImageChanged)
            .disposed(by: disposeBag)

        inputs.createLog
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .compactMap { [weak self] _ in
                self?.logForm
            }.flatMap { [weak self] logForm in
                if self?.writeLogMode == WriteLogMode.create {
                    return logAPIService.create(form: logForm)
                } else {
                    return logAPIService.edit(form: logForm)
                }
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(data):
                    switch data {
                    case .succeed:
                        self?.routes.backward.onNext(true)
                    case .fail:
                        self?.toast.onNext("다시 시도해주세요!")
                    case .needLogin:
                        self?.toast.onNext("로그인이 필요합니다")
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    }
                }
            }).disposed(by: disposeBag)

        inputs.isPrivacyOn
            .bind { [weak self] isOn in
                self?.logForm.isOpened = isOn
            }.disposed(by: disposeBag)

        routeInputs.selectedLogStamp
            .map { [weak self] selectedLogStamp in
                self?.selectedLogStamp = selectedLogStamp
                self?.logForm.stampCode = selectedLogStamp.rawValue
                return selectedLogStamp
            }
            .bind(to: outputs.selectedLogStamp)
            .disposed(by: disposeBag)

        routeInputs.selectedWeather
            .map { [weak self] selectedStamp, selecteTemp in
                self?.weatherStamp = selectedStamp
                self?.weatherTemp = selecteTemp
                self?.logForm.weatherIcon = selectedStamp.rawValue
                self?.logForm.weatherDegree = Int(selecteTemp)
                return (selectedStamp, selecteTemp)
            }
            .bind(to: outputs.selectedWeather)
            .disposed(by: disposeBag)

        routeInputs.photoTypeSelected
            .compactMap { $0 }
            .bind(to: outputs.showPicker)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
