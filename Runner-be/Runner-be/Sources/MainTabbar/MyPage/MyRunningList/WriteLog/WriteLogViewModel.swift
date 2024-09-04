//
//  WriteLogViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import RxSwift

final class WriteLogViewModel: BaseViewModel {
    // MARK: - Properties

    struct Input {
        var showLogStampBottomSheet = PublishSubject<Void>()
        var tapPhotoButton = PublishSubject<Void>()
        var tapPhotoCancel = PublishSubject<Void>()
        var tapWeather = PublishSubject<Void>()
        var tapTogether = PublishSubject<Void>()
        var photoSelected = PublishSubject<Data?>()
    }

    struct Output {
        var selectedLogStamp = PublishSubject<LogStamp2>()
        var selectedWeather = PublishSubject<(LogStamp2, String)>()
        var showPicker = PublishSubject<EditProfileType>()
        var selectedImageChanged = PublishSubject<Data?>()
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var logStampBottomSheet = PublishSubject<(stamp: LogStamp2, title: String)>()
        var stampBottomSheet = PublishSubject<(stamp: LogStamp2, temp: String)>()
        var togetherRunner = PublishSubject<Void>()
        var photoModal = PublishSubject<Void>()
    }

    struct RouteInput {
        var selectedLogStamp = PublishSubject<LogStamp2>()
        var selectedWeather = PublishSubject<(stamp: LogStamp2, temp: String)>()
        var photoTypeSelected = PublishSubject<EditProfileType?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    var selectedLogStamp: LogStamp2?
    var weatherStamp: LogStamp2?
    var weatherTemp: String?

    // MARK: - Init

    init(postId _: Int) {
        super.init()

        inputs.showLogStampBottomSheet
            .map { [weak self] _ in
                guard let selectedLogStamp = self?.selectedLogStamp
                else { // FIXME: - 하드코딩
                    return (stamp: LogStamp2(
                        stampType: 1,
                        stampCode: "RUN001",
                        stampName: "Check!"
                    ), title: "스탬프")
                }
                return (selectedLogStamp, "스탬프")
            }
            .bind(to: routes.logStampBottomSheet)
            .disposed(by: disposeBag)

        inputs.tapPhotoButton
            .bind(to: routes.photoModal)
            .disposed(by: disposeBag)

        inputs.tapPhotoCancel
            .bind { [weak self] _ in
                print("sejfosliejfi")
                self?.outputs.selectedImageChanged.onNext(nil)
            }
            .disposed(by: disposeBag)

        inputs.tapWeather
            .map { [weak self] _ in
                guard let selectedStamp = self?.weatherStamp,
                      let selectedTemp = self?.weatherTemp
                else { // FIXME: - 하드코딩
                    return (stamp: LogStamp2(
                        stampType: 2,
                        stampCode: "WEA001",
                        stampName: "맑음"
                    ), temp: "-")
                }
                return (stamp: selectedStamp, temp: selectedTemp)
            }
            .bind(to: routes.stampBottomSheet)
            .disposed(by: disposeBag)

        inputs.tapTogether
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
                return data
            }
            .bind(to: outputs.selectedImageChanged)
            .disposed(by: disposeBag)

        routeInputs.selectedLogStamp
            .map { [weak self] selectedLogStamp in
                self?.selectedLogStamp = selectedLogStamp
                return selectedLogStamp
            }
            .bind(to: outputs.selectedLogStamp)
            .disposed(by: disposeBag)

        routeInputs.selectedWeather
            .map { [weak self] selectedStamp, selecteTemp in
                self?.weatherStamp = selectedStamp
                self?.weatherTemp = selecteTemp
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
