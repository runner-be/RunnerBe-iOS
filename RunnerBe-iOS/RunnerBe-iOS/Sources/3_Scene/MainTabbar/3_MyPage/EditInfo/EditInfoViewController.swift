//
//  EditInfoViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class EditInfoViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInputs()
    }

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
            .disposed(by: disposeBags)

        selectNickName.applyButton.rx.tap
            .compactMap { [unowned self] in self.selectNickName.nickNameField.text }
            .bind(to: viewModel.inputs.nickNameApply)
            .disposed(by: disposeBags)

        selectNickName.nickNameField.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.inputs.nickNameText)
            .disposed(by: disposeBags)

        profileImageView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.changePhoto)
            .disposed(by: disposeBags)

        selectJobView.jobGroup.tap
            .bind(to: viewModel.inputs.jobSelected)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        viewModel.outputs.currentJob
            .take(1)
            .subscribe(onNext: { [weak self] job in
                self?.selectJobView.select(idx: job.index)
            })
            .disposed(by: disposeBags)

        viewModel.outputs.showPicker
            .map { $0.sourceType }
            .subscribe(onNext: { [weak self] sourceType in
                guard let self = self else { return }
                let picker = UIImagePickerController()
                picker.sourceType = sourceType
                picker.allowsEditing = false
                picker.delegate = self
                self.present(picker, animated: true)
            })
            .disposed(by: disposeBags)

        viewModel.outputs.nickNameDup
            .subscribe(onNext: { [weak self] dup in
                self?.nickNameDupErrLabel.isHidden = !dup
                self?.selectNickName.applyButton.isEnabled = !dup
            })
            .disposed(by: disposeBags)

        viewModel.outputs.nickNameRuleOK
            .subscribe(onNext: { [weak self] ok in
                self?.nickNameRuleErrLabel.isHidden = ok
                self?.selectNickName.applyButton.isEnabled = ok
            })
            .disposed(by: disposeBags)

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
            .disposed(by: disposeBags)

        viewModel.outputs.profileChanged
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] data in
                self?.profileImageView.image = UIImage(data: data)
                self?.profileCameraIcon.isHidden = true
            })
            .disposed(by: disposeBags)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBags)
    }

    private func viewInputs() {
        selectNickName.nickNameField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.layer.borderWidth = 1
            })
            .disposed(by: disposeBags)

        selectNickName.nickNameField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.layer.borderWidth = 0
            })
            .disposed(by: disposeBags)

        view.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] recognizer in
                guard let self = self else { return false }
                return !self.selectNickName.nickNameField.frame.contains(recognizer.location(in: self.view))
            }
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.endEditing(true)
            })
            .disposed(by: disposeBags)

//        selectNickName.applyButton.rx.tap
//            .take(1)
//            .subscribe(onNext: { [weak self] in
//                self?.certificateButton.setTitle(L10n.EmailCertification.Button.Certificate.resend, for: .normal)
//                self?.certificateButton.setTitle(L10n.EmailCertification.Button.Certificate.resend, for: .disabled)
//            })
//            .disposed(by: disposeBags)
    }

    private var profileImageView = UIImageView().then { view in
        view.image = Asset.profileEmptyIcon.uiImage

        view.snp.makeConstraints { make in
            make.width.equalTo(78)
            make.height.equalTo(78)
        }

        view.layer.cornerRadius = 39
        view.clipsToBounds = true
    }

    private var profileCameraIcon = UIImageView().then { view in
        view.image = Asset.camera.uiImage

        view.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
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
        label.isHidden = true
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
        spacing: 1
    )

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG55
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var selectJobView = SelectJobView().then { view in
        view.titleLabel.text = L10n.MyPage.EditInfo.Job.title
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
        gradientBackground()

        view.addSubviews([
            navBar,
            profileImageView,
            profileCameraIcon,
            selectNickName,
            vStack,
            hDivider,
            selectJobView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.centerX.equalTo(view.snp.centerX)
        }

        profileCameraIcon.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.centerX.equalTo(profileImageView.snp.trailing)
        }

        selectNickName.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
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
            make.leading.equalTo(selectNickName.snp.leading)
            make.trailing.equalTo(selectNickName.snp.trailing)
        }

        selectJobView.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(24)
            make.leading.equalTo(selectNickName.snp.leading)
            make.trailing.equalTo(selectNickName.snp.trailing)
        }
    }

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.bgBottom.cgColor,
            UIColor.bgTop.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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

// MARK: - UIImagePickerViewController Delegate

extension EditInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage
        viewModel.inputs.photoSelected.onNext(image?.pngData())
        picker.dismiss(animated: true)
    }
}
