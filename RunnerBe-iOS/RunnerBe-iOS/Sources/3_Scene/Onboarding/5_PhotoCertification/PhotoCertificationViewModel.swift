//
//  PhotoCertificationViewModel.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import RxSwift

enum ImagePickerType {
    case library
    case camera
}

final class PhotoCertificationViewModel: BaseViewModel {
    private let signupService: SignupService
    private var image: Data?

    init(signupService: SignupService) {
        self.signupService = signupService
        super.init()

        inputs.tapPhoto
            .subscribe(routes.photoModal)
            .disposed(by: disposeBag)

        inputs.tapBackward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.tapCancel
            .subscribe(routes.cancel)
            .disposed(by: disposeBag)

        inputs.tapDeletePhoto
            .subscribe(onNext: { [weak self] in
                self?.image = nil
                self?.outputs.idCardImage.onNext(nil)
                self?.outputs.enableCertificate.onNext(false)
            })
            .disposed(by: disposeBag)

        routeInputs.photoModal
            .compactMap { $0 }
            .subscribe(routes.showPicker)
            .disposed(by: disposeBag)

        routeInputs.photoModal
            .map { $0 != nil }
            .subscribe(outputs.enableCertificate)
            .disposed(by: disposeBag)

        inputs.photoSelected
            .subscribe(onNext: { [weak self] data in
                self?.image = data
            })
            .disposed(by: disposeBag)

        inputs.tapCertificate
            .do(onNext: { [weak self] _ in
                self?.outputs.enableCertificate.onNext(false)
            })
            .map { [weak self] () -> Observable<SignupWithIdCardResult> in
                guard let self = self,
                      let data = self.image
                else { return .just(.imageUploadFail) }
                return self.signupService.certificateIdCardImage(data)
            }
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .imageUploaded:
                    self?.routes.certificate.onNext(())
                case .imageUploadFail:
                    // TODO: 이미지 업로드 실패시 안내문구? 추가
                    break
                case .needUUID:
                    // TODO: UUID 오류시 해결방안 생각해보기
                    break
                }
                self?.outputs.enableCertificate.onNext(true)
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapCancel = PublishSubject<Void>()
        var tapBackward = PublishSubject<Void>()
        var tapPhoto = PublishSubject<Void>()
        var tapDeletePhoto = PublishSubject<Void>()
        var tapCertificate = PublishSubject<Void>()
        var photoSelected = PublishSubject<Data?>()
    }

    struct Output {
        var idCardImage = PublishSubject<Data?>()
        var enableCertificate = PublishSubject<Bool>()
    }

    struct Route {
        var photoModal = PublishSubject<Void>()
        var showPicker = PublishSubject<ImagePickerType>()
        var backward = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
        var certificate = PublishSubject<Void>()
    }

    struct RouteInput {
        var photoModal = PublishSubject<ImagePickerType?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
