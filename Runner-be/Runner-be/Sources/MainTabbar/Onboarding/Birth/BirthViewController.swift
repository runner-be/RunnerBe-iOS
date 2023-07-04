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

final class BirthViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: BirthViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: BirthViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: { [weak self] in
                self?.nextButton.isEnabled = $0
                self?.errorLabel.isHidden = $0
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.attributedText = NSMutableAttributedString()
            .style(to: "2", attributes: [
                .font: UIFont.iosBody17Sb,
                .foregroundColor: UIColor.primarydark,
            ])
            .style(to: "/4", attributes: [
                .font: UIFont.iosBody17Sb,
                .foregroundColor: UIColor.darkG35,
            ])
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel = UILabel().then { label in
        var font = UIFont.aggroLight.withSize(26)
        label.font = font
        label.setTextWithLineHeight(text: L10n.Onboarding.PolicyTerm.title, with: 42)
        label.text = L10n.Onboarding.Birth.title
        label.textColor = .primary
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var subTitleLabel1 = UILabel().then { label in
        label.font = .iosBody15R
        label.setTextWithLineHeight(text: L10n.Onboarding.Birth.subTitle1, with: 22)
        label.textColor = .darkG25
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var subTitleLabel2 = UILabel().then { label in
        label.font = .iosBody15R
        label.setTextWithLineHeight(text: L10n.Onboarding.Birth.subTitle2, with: 22)
        label.textColor = .darkG25
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var pickerView = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
    }

    private var errorLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.text = L10n.Onboarding.Birth.Error.age
        label.textColor = .errorlight
    }

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.Onboarding.Birth.Button.next, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.Onboarding.Birth.Button.next, for: .disabled)
        button.setTitleColor(UIColor.darkG4, for: .disabled)
        button.setBackgroundColor(UIColor.darkG5, for: .disabled)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true
        button.isEnabled = false
    }
}

// MARK: - Layout

extension BirthViewController {
    private func setupViews() {
        view.backgroundColor = .darkG7

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.currentSelectedRow = 0

        view.addSubviews([
            navBar,
            titleLabel,
            subTitleLabel1,
            subTitleLabel2,
            pickerView,
            errorLabel,
            nextButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(26)
            make.leading.equalTo(16)
            make.trailing.equalTo(view.snp.trailing).offset(-51)
        }

        subTitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-107)
        }

        subTitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-107)
        }

        pickerView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel2.snp.bottom).offset(58)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-27)
            make.height.equalTo(184)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(12)
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
        print(didSelectRow)
        viewModel.inputs.itemSelected.onNext(didSelectRow)
    }
}
