//
//  EmailCertificationInitModalViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import PickerView
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class SelectTimeModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SelectTimeModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: SelectTimeModalViewModel

    private func viewModelInput() {
        sheet.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)

        view.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }).when(.recognized)
            .map { _ in }
            .subscribe(viewModel.inputs.tapBackground)
            .disposed(by: disposeBag)

        buttonOk.rx.tap
            .bind(to: viewModel.inputs.tapOK)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    private lazy var timePicker = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 0
        picker.delegate = self
        picker.dataSource = self
    }

    private lazy var minutePicker = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 1
        picker.delegate = self
        picker.dataSource = self
    }

    private var timeLabel = UILabel().then { label in
        label.font = .iosBody17Sb
        label.textColor = .primary
        label.text = L10n.Post.Modal.Time.time
    }

    private var minuteLabel = UILabel().then { label in
        label.font = .iosBody17Sb
        label.textColor = .primary
        label.text = L10n.Post.Modal.Time.minute
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var buttonOk = UIButton().then { button in
        button.setTitle(L10n.Modal.SelectTime.Button.ok, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)

        button.titleLabel?.font = .iosBody17R
    }
}

// MARK: - Layout

extension SelectTimeModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            timePicker,
            timeLabel,
            minutePicker,
            minuteLabel,
            hDivider,
            buttonOk,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }

        timePicker.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(sheet.snp.leading).offset(61)
            make.height.equalTo(120)
            make.width.equalTo(25)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timePicker.snp.centerY)
            make.leading.equalTo(timePicker.snp.trailing).offset(16)
        }

        minutePicker.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(timeLabel.snp.trailing).offset(56)
            make.height.equalTo(timePicker)
            make.width.equalTo(30)
        }

        minuteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minutePicker.snp.centerY)
            make.leading.equalTo(minutePicker.snp.trailing).offset(16)
            make.trailing.equalTo(sheet.snp.trailing).offset(-61)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(timePicker.snp.bottom).offset(23)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(1)
        }

        buttonOk.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(hDivider.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
        }
    }
}

extension SelectTimeModalViewController: PickerViewDelegate, PickerViewDataSource {
    func pickerViewHeightForRows(_: PickerView) -> CGFloat {
        30
    }

    func pickerView(_ picker: PickerView, titleForRow row: Int) -> String {
        switch picker.tag {
        case 0:
            return viewModel.outputs.timeItems[row]
        case 1:
            return viewModel.outputs.minuteItems[row]
        default:
            return ""
        }
    }

    func pickerView(_: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if highlighted {
            label.font = .iosBody17Sb.withSize(22)
            label.textColor = .primary
        } else {
            label.font = .iosTitle19R.withSize(19)
            label.textColor = .darkG4
        }
    }

    func pickerViewNumberOfRows(_ picker: PickerView) -> Int {
        switch picker.tag {
        case 0:
            return viewModel.outputs.timeItems.count
        case 1:
            return viewModel.outputs.minuteItems.count
        default:
            return 0
        }
    }

    func pickerView(_ picker: PickerView, didSelectRow: Int) {
        switch picker.tag {
        case 0:
            viewModel.inputs.timeSelected = didSelectRow
        case 1:
            viewModel.inputs.minuteSelected = didSelectRow
        default:
            break
        }
    }
}
