//
//  EditInfoViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Kingfisher
// import Photos
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class EditInfoViewController: BaseViewController {
    lazy var editInfoDataManager = EditInfoDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInputs()

        editInfoDataManager.getMyPage(viewController: self)
    }

    // TODO: 유저 이미지 연결
    init(viewModel: EditInfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: EditInfoViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        selectNickName.applyButton.rx.tap
            .compactMap { [unowned self] in self.selectNickName.nickNameField.text }
            .bind(to: viewModel.inputs.nickNameApply)
            .disposed(by: disposeBag)

        selectNickName.nickNameField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: viewModel.inputs.nickNameText)
            .disposed(by: disposeBag)

//        profileImageView.rx.tapGesture()
//            .when(.recognized)
//            .map { _ in }
//            .bind(to: viewModel.inputs.changePhoto)
//            .disposed(by: disposeBag)

        selectJobView.jobGroup.tap
            .bind(to: viewModel.inputs.jobSelected)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.currentJob
            .take(1)
            .subscribe(onNext: { [weak self] job in
                self?.selectJobView.select(idx: job.index)
            })
            .disposed(by: disposeBag)

//        viewModel.outputs.currentProfile
//            .take(1)
//            .compactMap { $0 }
//            .compactMap { URL(string: $0) }
//            .subscribe(onNext: { [weak self] url in
//                self?.profileImageView.kf.setImage(with: url)
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.showPicker
//            .map { $0.sourceType }
//            .subscribe(onNext: { [weak self] sourceType in
//                guard let self = self else { return }
//                let picker = UIImagePickerController()
//                picker.sourceType = sourceType
//                picker.allowsEditing = true
//                picker.delegate = self
//                switch sourceType {
//                case .photoLibrary:
//                    PHPhotoLibrary.requestAuthorization { [weak self] status in
//                        DispatchQueue.main.async {
//                            switch status {
//                            case .authorized:
//                                self?.present(picker, animated: true)
//                            default:
//                                self?.view.makeToast("설정화면에서 앨범 접근권한을 설정해주세요")
//                            }
//                        }
//                    }
//                case .camera:
//                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] ok in
//                        DispatchQueue.main.async {
//                            if ok {
//                                self?.present(picker, animated: true)
//                            } else {
//                                self?.view.makeToast("설정화면에서 카메라 접근권한을 설정해주세요")
//                            }
//                        }
//                    })
//                default:
//                    break
//                }
//        //                switch sourceType {
//        //                case .photoLibrary:
//        //                    if self.photoAuth() {
//        //                        self.present(picker, animated: true)
//        //                    } else {
//        //                        self.authSettingOpen(authString: "앨범 권한 설정")
//        //                    }
//        //                case .camera:
//                ////                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] ok in
//                ////                        DispatchQueue.main.async {
//                ////                            if ok {
//                ////                                self?.present(picker, animated: true)
//                ////                            } else {
//                ////                                self?.view.makeToast("권한이 없어 카메라에 접근할 수 없습니다.")
//                ////                            }
//                ////                        }
//                ////                    })
//        //                    if self.cameraAuth() {
//        //                        self.present(picker, animated: true)
//        //                    } else {
//        //                        self.authSettingOpen(authString: "카메라 권한 설정")
//        //                    }
//        //                default:
//        //                    break
//        //                }
//            })
//            .disposed(by: disposeBag)

        viewModel.outputs.nickNameDup // 닉네임 중복처리
            .subscribe(onNext: { [weak self] dup in
                self?.nickNameDupErrLabel.isHidden = !dup
                self?.selectNickName.applyButton.isEnabled = !dup
            })
            .disposed(by: disposeBag)

        viewModel.outputs.nickNameRuleOK // 유효성 검증
            .subscribe(onNext: { [weak self] ok in
                self?.nickNameRuleErrLabel.isHidden = ok
                self?.selectNickName.applyButton.isEnabled = ok
//                print("hello \(self?.selectNickName.applyButton.isEnabled)")
            })
            .disposed(by: disposeBag)

        viewModel.outputs.nickNameAlreadyChanged
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.nickNameGuideLabel.isHidden = false
                self?.nickNameRuleErrLabel.isHidden = true
                self?.nickNameDupErrLabel.isHidden = true
                self?.selectNickName.nickNameField.isEnabled = false
                self?.selectNickName.disableWithPlaceHolder(
                    fieldText: nil,
                    // "MyPage.EditInfo.NickName.Button.CANNT" = "변경불가";

                    buttonText: L10n.MyPage.EditInfo.NickName.Button.cant
                )
            })
            .disposed(by: disposeBag)

        viewModel.outputs.nickNameChanged
            .subscribe(onNext: { [weak self] newName in
                self?.selectNickName.disableWithPlaceHolder(
                    fieldText: newName,
                    buttonText: L10n.MyPage.EditInfo.NickName.Button.NickNameChanged.title
                )
                self?.nickNameGuideLabel.text = L10n.MyPage.EditInfo.NickName.InfoLabel.alreadychanged
                self?.nickNameGuideLabel.isHidden = false
                self?.nickNameRuleErrLabel.isHidden = true
                self?.nickNameRuleErrLabel.isHidden = true
            })
            .disposed(by: disposeBag)

//        viewModel.outputs.profileChanged
//            .compactMap { $0 }
//            .subscribe(onNext: { [weak self] data in
//                self?.profileImageView.image = UIImage(data: data)
//                self?.profileCameraIcon.isHidden = true
//            })
//            .disposed(by: disposeBag)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.toastActivity
            .subscribe(onNext: { [weak self] show in
                if show {
                    self?.view.makeToastActivity(.center)
                } else {
                    self?.view.hideToastActivity()
                }
            })
            .disposed(by: disposeBag)
    }

    private func viewInputs() {
        selectNickName.nickNameField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.layer.borderWidth = 1
            })
            .disposed(by: disposeBag)

        selectNickName.nickNameField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)

        view.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] recognizer in
                guard let self = self else { return false }
                return !self.selectNickName.nickNameField.frame.contains(recognizer.location(in: self.view))
            }
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.endEditing(true)
            })
            .disposed(by: disposeBag)
    }

    private lazy var selectNickName = TextFieldWithButton().then { view in
        view.titleLabel.text = L10n.MyPage.EditInfo.NickName.title
        view.applyButton.setTitle(L10n.MyPage.EditInfo.NickName.Button.apply, for: .normal)
        view.setPlaceHolder(to: L10n.MyPage.EditInfo.NickName.TextField.PlaceHolder.rule)
        view.nickNameField.delegate = self
    }

    private var nickNameGuideLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .primary
        label.text = L10n.MyPage.EditInfo.NickName.InfoLabel.caution
        label.isHidden = false
    }

    private var nickNameDupErrLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .errorlight
        label.text = L10n.MyPage.EditInfo.NickName.ErrorLabel.duplicated
        label.isHidden = true
    }

    private var nickNameRuleErrLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .errorlight
        label.text = L10n.MyPage.EditInfo.NickName.ErrorLabel.form
        label.isHidden = true
    }

    private lazy var vStack = UIStackView.make(
        with: [nickNameGuideLabel, nickNameDupErrLabel, nickNameRuleErrLabel],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 4
    )

    private var hDivider = UIView().then { view in
        view.backgroundColor = .black
        view.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
    }

    private var selectJobView = SelectJobView().then { view in
        view.titleLabel.text = L10n.MyPage.EditInfo.Job.title
        view.isHidden = false
    }

    private var selectJobGuideLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .primary
        label.text = L10n.MyPage.EditInfo.Job.ErrorLabel.cannotIn3Month
        label.isHidden = true // 처음엔 노출 안되게
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MyPage.EditInfo.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.titleLabel.font = .iosBody17Sb
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension EditInfoViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            selectNickName,
            vStack,
            hDivider,
            selectJobView,
            selectJobGuideLabel,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        selectNickName.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        vStack.snp.makeConstraints { make in
            make.top.equalTo(selectNickName.snp.bottom).offset(12)
            make.leading.equalTo(selectNickName.snp.leading)
            make.trailing.equalTo(selectNickName.snp.trailing)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(vStack.snp.bottom).offset(27)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        selectJobView.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(24)
            make.leading.equalTo(selectNickName.snp.leading)
            make.trailing.equalTo(selectNickName.snp.trailing)
        }

        selectJobGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(selectJobView.snp.bottom).offset(24)
            make.leading.equalTo(selectJobView.snp.leading)
        }
    }
}

// MARK: - UITextFieldDelegate Delegate

extension EditInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText)
        else { return false }

        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 8
    }
}

//// MARK: - UIImagePickerViewController Delegate
//
// extension EditInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        let originalImage = info[.originalImage] as? UIImage
//        let editedImage = info[.editedImage] as? UIImage
//        let editedResizedImage = editedImage?.resize(newWidth: 300)
//        let originalResizedImage = originalImage?.resize(newWidth: 300)
//        viewModel.inputs.photoSelected.onNext(editedResizedImage?.pngData() ?? originalResizedImage?.pngData())
//        picker.dismiss(animated: true)
//    }
//
//    func photoAuth() -> Bool {
//        let authorizationState = PHPhotoLibrary.authorizationStatus()
//        var isAuth = false
//
//        switch authorizationState {
//        case .authorized:
//            return true
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization { state in
//                if state == .authorized {
//                    isAuth = true
//                }
//            }
//            return isAuth
//        case .restricted:
//            break
//        case .denied:
//            break
//        case .limited:
//            break
//        @unknown default:
//            break
//        }
//        return false
//    }
//
//    func cameraAuth() -> Bool {
//        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
//    }
//
//    func authSettingOpen(authString: String) {
//        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
//            let message = "\(AppName)이(가) \(authString) 접근 허용이 되어있지 않습니다. \r\n 설정화면으로 가시겠습니까?"
//            let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
//
//            let cancel = UIAlertAction(title: "취소", style: .default) { action in
//                alert.dismiss(animated: true, completion: nil)
//                print("\(String(describing: action.title)) 클릭")
//            }
//
//            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
//                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//            }
//
//            alert.addAction(cancel)
//            alert.addAction(confirm)
//
//            present(alert, animated: true, completion: nil)
//        }
//    }
// }

extension EditInfoViewController {
    func didSuccessGetUserMyPage(_ result: GetMyPageResult) {
        if result.myInfo?[0].nameChanged == "Y" {
            nickNameGuideLabel.text = L10n.MyPage.EditInfo.NickName.InfoLabel.alreadychanged
            selectNickName.nickNameField.isEnabled = false
            selectNickName.applyButton.isEnabled = false
            selectNickName.applyButton.setTitle(L10n.MyPage.EditInfo.NickName.Button.NickNameChanged.title, for: .disabled)
        } else {
            nickNameGuideLabel.text = L10n.MyPage.EditInfo.NickName.InfoLabel.caution
//            selectNickName.applyButton.isEnabled = true
            selectNickName.applyButton.setTitle(L10n.MyPage.EditInfo.NickName.Button.apply, for: .normal)
        }
    }

    func failedToRequest(message: String) {
        print(message)
    }
}
