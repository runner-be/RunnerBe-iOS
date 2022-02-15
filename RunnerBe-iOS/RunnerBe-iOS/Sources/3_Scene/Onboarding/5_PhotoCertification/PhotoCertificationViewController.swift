//
//  PhotoCertificationViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

extension ImagePickerType {
    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .library:
            return .photoLibrary
        }
    }
}

final class PhotoCertificationViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: PhotoCertificationViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: PhotoCertificationViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBags)

        photoView.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] _ in
                self?.photoView.image == nil
            }
            .map { _ in }
            .subscribe(viewModel.inputs.tapPhoto)
            .disposed(by: disposeBags)

        photoView.deleteIconTapped
            .subscribe(viewModel.inputs.tapDeletePhoto)
            .disposed(by: disposeBags)

        certificateButton.rx.tap
            .subscribe(viewModel.inputs.tapCertificate)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableCertificate
            .subscribe(onNext: { [weak self] enable in
                self?.certificateButton.isEnabled = enable
            })
            .disposed(by: disposeBags)

        viewModel.outputs.idCardImage
            .subscribe(onNext: { [weak self] data in
                self?.photoView.image = data != nil ? UIImage(data: data!) : nil
            })
            .disposed(by: disposeBags)

        viewModel.routes.showPicker
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
    }

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.text = L10n.PhotoCertification.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel1 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.PhotoCertification.title1
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.PhotoCertification.title2
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var subTitleLabel1 = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.subTitle1
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var subTitleLabel2 = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.subTitle2
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var photoView = PhotoChoosableView().then { view in
        view.layer.borderColor = UIColor.darkG25.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.image = nil
    }

    private var ruleLabel1 = UILabel().then { label in
        label.attributedText = NSMutableAttributedString()
            .style(to: L10n.PhotoCertification.ImageRule.emoji + " ",
                   attributes: [
                       .font: UIFont.iosBody15R,
                       .foregroundColor: UIColor.darkG25,
                   ])
            .style(to: L10n.PhotoCertification.ImageRule.No1.highlighted,
                   attributes: [
                       .font: UIFont.iosBody15B,
                       .foregroundColor: UIColor.darkG25,
                       .underlineStyle: NSUnderlineStyle.single.rawValue,
                       .underlineColor: UIColor.darkG25,
                   ])
            .style(to: L10n.PhotoCertification.ImageRule.No1.normal,
                   attributes: [
                       .font: UIFont.iosBody15R,
                       .foregroundColor: UIColor.darkG25,
                   ])
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var ruleLabel2 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.ImageRule.emoji + " "
            + L10n.PhotoCertification.ImageRule.no2
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var ruleLabel3 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG25
        label.text = L10n.PhotoCertification.ImageRule.emoji + " "
            + L10n.PhotoCertification.ImageRule.no3
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private lazy var ruleLabelVStack = UIStackView.make(
        with: [ruleLabel1, ruleLabel2, ruleLabel3],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 2
    )

    private var certificateButton = UIButton().then { button in
        button.setTitle(L10n.PhotoCertification.Button.Certificate.title, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.PhotoCertification.Button.Certificate.title, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.titleLabel?.font = .iosBody15R

        button.clipsToBounds = true

        button.isEnabled = false
    }
}

// MARK: - Layout

extension PhotoCertificationViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            titleLabel1,
            titleLabel2,
            subTitleLabel1,
            subTitleLabel2,
            photoView,
            ruleLabelVStack,

            certificateButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(26)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-39)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-39)
        }

        subTitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(18)
            make.trailing.equalTo(view.snp.trailing).offset(-58)
        }

        subTitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(18)
            make.trailing.equalTo(view.snp.trailing).offset(-58)
        }

        photoView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel2.snp.bottom).offset(76)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(193)
        }

        ruleLabelVStack.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-50)
        }

        certificateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        certificateButton.layer.cornerRadius = 24
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

// MARK: - UIImagePickerViewController Delegate

extension PhotoCertificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage
        photoView.image = image
        viewModel.inputs.photoSelected.onNext(image?.pngData())
        picker.dismiss(animated: true)
    }
}
