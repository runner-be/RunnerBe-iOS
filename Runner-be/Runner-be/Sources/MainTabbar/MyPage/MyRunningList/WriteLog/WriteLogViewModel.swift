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
        var photoSelected = PublishSubject<Data?>()
    }

    struct Output {
        var selectedLogStamp = PublishSubject<LogStamp2>()
        var showPicker = PublishSubject<EditProfileType>()
        var selectedImageChanged = PublishSubject<Data?>()
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var logStampBottomSheet = PublishSubject<LogStamp2>()
        var photoModal = PublishSubject<Void>()
    }

    struct RouteInput {
        var selectedLogStamp = PublishSubject<LogStamp2>()
        var photoTypeSelected = PublishSubject<EditProfileType?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()

    var selectedLogStamp: LogStamp2?

    // MARK: - Init

    init(postId _: Int) {
        super.init()

        inputs.showLogStampBottomSheet
            .map { [weak self] _ in
                guard let selectedLogStamp = self?.selectedLogStamp
                else { // FIXME: - 하드코딩
                    return LogStamp2(
                        stampType: 1,
                        stampCode: "RUN001",
                        stampName: "Check!"
                    )
                }
                return selectedLogStamp
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

        routeInputs.photoTypeSelected
            .compactMap { $0 }
            .bind(to: outputs.showPicker)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
}
