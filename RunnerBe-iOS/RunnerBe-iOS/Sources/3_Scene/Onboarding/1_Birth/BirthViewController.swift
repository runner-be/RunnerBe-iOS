//
//  BirthViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import PickerView
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BirthViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        bindViewModelInput()
        bindViewModelOutput()
    }

    init(viewModel: BirthViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func bindViewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBags)

        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBags)
    }

    func bindViewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: {
                self.nextButton.isEnabled = $0
                self.errorLabel.isHidden = $0
            })
            .disposed(by: disposeBags)
    }

    // MARK: Private

    private var viewModel: BirthViewModel

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.text = "TITLE"
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel = UILabel().then { label in
        label.font = .iosHeader31Sb
        label.text = L10n.Birth.title
        label.textColor = .primary
    }

    private var subTitleLabel1 = UILabel().then { label in
        label.font = .iosBody15R
        label.text = L10n.Birth.subTitle1
        label.textColor = .darkG25
    }

    private var subTitleLabel2 = UILabel().then { label in
        label.font = .iosBody15R
        label.text = L10n.Birth.subTitle2
        label.textColor = .darkG25
    }

    private var pickerView = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
    }

    private var hDivider1 = UIView().then { view in
        view.backgroundColor = .darkG5
    }

    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG5
    }

    private var errorLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.text = L10n.Birth.Error.age
        label.textColor = .errorlight
    }

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.PolicyTerm.Button.Next.title, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.PolicyTerm.Button.Next.title, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.clipsToBounds = true
        button.isEnabled = false
    }
}

// MARK: - Layout

extension BirthViewController {
    private func setupViews() {
        gradientBackground()

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.currentSelectedRow = 0

        view.addSubviews([
            navBar,
            titleLabel,
            subTitleLabel1,
            subTitleLabel2,
            hDivider1,
            pickerView,
            hDivider2,
            errorLabel,
            nextButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(26)
            make.leading.equalTo(16)
        }

        subTitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        subTitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        hDivider1.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel2.snp.bottom).offset(76)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-27)
            make.height.equalTo(1)
        }

        pickerView.snp.makeConstraints { make in
            make.top.equalTo(hDivider1.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-27)
            make.height.equalTo(180)
        }

        hDivider2.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-27)
            make.height.equalTo(1)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(hDivider2.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        nextButton.layer.cornerRadius = 24
    }

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.darkG6.cgColor,
            UIColor.darkG55.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - PickerViewDelegate, PickerViewDataSource

extension BirthViewController: PickerViewDelegate, PickerViewDataSource {
    func pickerViewHeightForRows(_: PickerView) -> CGFloat {
        45
    }

    func pickerView(_: PickerView, titleForRow row: Int) -> String {
        viewModel.outputs.items[row].description
    }

    func pickerView(_: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if highlighted {
            label.font = .iosBody17Sb.withSize(30)
            label.textColor = .primary
        } else {
            label.font = .iosBody17R.withSize(23)
            label.textColor = .darkG4
        }
    }

    func pickerViewNumberOfRows(_: PickerView) -> Int {
        viewModel.outputs.items.count
    }

    func pickerView(_: PickerView, didSelectRow: Int) {
        viewModel.inputs.itemSelected.onNext(didSelectRow)
    }
}
