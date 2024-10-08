//
//  WriteLogViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import Photos
import UIKit

final class WriteLogViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: WriteLogViewModel

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "2024년 0월 0일 월요일"
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }

    private lazy var vStackView = UIStackView.make(
        with: [
            logStampView,
            hDivider1,
            logDiaryView,
            hDivider2,
            privacyToggleView,
            registerButton,
            UIView(),
        ],
        axis: .vertical,
        spacing: 24
    )

    private let logStampView = WriteLogStampView()

    private var hDivider1 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let logDiaryView = WriteLogDiaryView(type: .write)

    private let hDivider2 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let privacyToggleView = WriteLogToggleView()

    private let registerButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.darkG6, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold15
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .primary
    }

    // MARK: - Init

    init(
        viewModel: WriteLogViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInput()

        viewModelInput()
        viewModelOutput()

        logDiaryView.textView.delegate = self

        dismissKeyboardWhenTappedAround()
    }

    // MARK: - Methods

    private func viewInput() {
        logDiaryView.textView.rx.text
            .bind { [weak self] inputText in
                guard let self = self else { return }
                let inputText = inputText ?? ""
                logDiaryView.countLabel.text = "\(inputText.count)/500"
            }
            .disposed(by: disposeBag)
    }

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backwardModal)
            .disposed(by: disposeBag)

        logStampView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.showLogStampBottomSheet)
            .disposed(by: disposeBag)

        logDiaryView.textView.rx.text
            .bind(to: viewModel.inputs.contents)
            .disposed(by: disposeBag)

        logDiaryView.imageButton.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.tapPhotoButton)
            .disposed(by: disposeBag)

        logDiaryView.selectedImageView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.tapPhotoCancel)
            .disposed(by: disposeBag)

        logDiaryView.weatherView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.tapWeather)
            .disposed(by: disposeBag)

        logDiaryView.participantView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.tapTogether)
            .disposed(by: disposeBag)

        privacyToggleView.toggleButton.toggleObservable
            .map {
                $0 ? 1 : 2
            }
            .bind(to: viewModel.inputs.isPrivacyOn)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .bind(to: viewModel.inputs.createLog)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.logDate
            .bind(to: navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.initialLogForm
            .subscribe(onNext: { [weak self] logForm in
                self?.setupInitialUI(with: logForm)
            }).disposed(by: disposeBag)

        viewModel.outputs.logPartners
            .subscribe(onNext: { [weak self] logPartners, gatheringId in
                self?.logDiaryView.updateGathering(
                    gatheringCount: logPartners.count,
                    gatheringId: gatheringId
                )
            }).disposed(by: disposeBag)

        viewModel.outputs.selectedLogStamp
            .bind { [weak self] selectedLogStamp in
                self?.logStampView.update(stampType: selectedLogStamp)
            }.disposed(by: disposeBag)

        viewModel.outputs.selectedWeather
            .bind { [weak self] selectedLogStamp, selectedTemp in
                self?.logDiaryView.update(
                    with: selectedLogStamp,
                    temp: selectedTemp
                )
            }.disposed(by: disposeBag)

        viewModel.outputs.showPicker
            .map { $0.sourceType }
            .subscribe(onNext: { [weak self] sourceType in
                guard let self = self else { return }
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                switch sourceType {
                case "library": // 갤러리
                    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    PHPhotoLibrary.requestAuthorization { [weak self] status in
                        DispatchQueue.main.async {
                            switch status {
                            case .authorized:
                                self?.present(picker, animated: true)
                            default:
                                AppContext.shared.makeToast("설정화면에서 앨범 접근권한을 설정해주세요")
                            }
                        }
                    }
                case "camera": // 카메라
                    picker.sourceType = UIImagePickerController.SourceType.camera
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] ok in
                        DispatchQueue.main.async {
                            if ok {
                                AppContext.shared.rootNavigationController?.present(picker, animated: true)
                            } else {
                                AppContext.shared.makeToast("설정화면에서 카메라 접근권한을 설정해주세요")
                            }
                        }
                    })
                default: // 기본 이미지로 변경
                    break
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.selectedImageChanged
            .subscribe(onNext: { [weak self] data in
                if let data = data {
                    self?.logDiaryView.selectedImageView.image = UIImage(data: data)
                    self?.logDiaryView.selectedImageView.isHidden = false
                } else {
                    self?.logDiaryView.selectedImageView.image = nil
                    self?.logDiaryView.selectedImageView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupInitialUI(with logForm: LogForm) {
        if let contents = logForm.contents,
           !contents.isEmpty,
           contents != ""
        {
            logDiaryView.textView.text = contents
            logDiaryView.textView.placeholder = ""
        }

        // 이미지 URL에서 이미지를 로드하여 selectedImageView에 설정
        if let imageURLString = logForm.imageUrl,
           let imageURL = URL(string: imageURLString)
        {
            logDiaryView.selectedImageView.kf.setImage(with: imageURL)
            logDiaryView.selectedImageView.isHidden = false
        }

        if let runningStamp = StampType(rawValue: logForm.stampCode ?? "") {
            logStampView.update(stampType: runningStamp)
        }

        if let weatherStamp = StampType(rawValue: logForm.weatherIcon ?? ""),
           let weatherDegree = logForm.weatherDegree
        {
            logDiaryView.updateWeather(stamp: weatherStamp, degree: "\(weatherDegree)")
        }

        logDiaryView.updateGathering(
            gatheringCount: 0,
            gatheringId: logForm.gatheringId
        )

        privacyToggleView.toggleButton.isOn = logForm.isOpened == 1
    }
}

// MARK: - UIImagePickerViewController Delegate

extension WriteLogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let originalImage = info[.originalImage] as? UIImage
        let editedImage = info[.editedImage] as? UIImage
        let editedResizedImage = editedImage?.resize(newWidth: 300)
        let originalResizedImage = originalImage?.resize(newWidth: 300)
        viewModel.inputs.photoSelected.onNext(editedResizedImage?.pngData() ?? originalResizedImage?.pngData())
        picker.dismiss(animated: true)
    }

    func photoAuth() -> Bool {
        let authorizationState = PHPhotoLibrary.authorizationStatus()
        var isAuth = false

        switch authorizationState {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted:
            break
        case .denied:
            break
        case .limited:
            break
        @unknown default:
            break
        }
        return false
    }

    func cameraAuth() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }

    func authSettingOpen(authString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(authString) 접근 허용이 되어있지 않습니다. \r\n 설정화면으로 가시겠습니까?"
            let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)

            let cancel = UIAlertAction(title: "취소", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
                print("\(String(describing: action.title)) 클릭")
            }

            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }

            alert.addAction(cancel)
            alert.addAction(confirm)

            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - TextViewDelegate

extension WriteLogViewController: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        // FIXME: 하드코딩
        let lineHeight = 22.0 // logDiaryView.textView.font?.lineHeight ?? 0

        let maxHeight = lineHeight * 5 // 최대 5줄까지만 입력 허용
        if logDiaryView.textView.contentSize.height > maxHeight {
            // 텍스트가 최대 라인 수를 초과할 경우 마지막 입력을 제거
            logDiaryView.textView.text = String(logDiaryView.textView.text.dropLast())
        }

        // 레이아웃 업데이트를 위해 뷰를 강제로 재배치
        logDiaryView.textView.snp.updateConstraints {
            $0.height.equalTo(logDiaryView.textView.contentSize.height)
        }

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Layout

extension WriteLogViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            scrollView,
        ])

        scrollView.addSubview(vStackView)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }

        vStackView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(24)
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        logDiaryView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }

        registerButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }

        privacyToggleView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
