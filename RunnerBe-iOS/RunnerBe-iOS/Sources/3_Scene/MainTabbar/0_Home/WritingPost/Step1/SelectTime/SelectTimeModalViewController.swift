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
        buttonOk.rx.tap
            .bind(to: viewModel.inputs.tapOK)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {}

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    let dayItem = ["3/31 (목)", "4/1 (금)", "4/2 (토)", "4/3 (일)", "4/4 (월)", "4/5 (화)", "4/6 (수)", "4/7 (목)"]
    let morningAfterNoon = ["AM", "PM"]
    let timeItem = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
    let minuteItem = ["00", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]

    private lazy var datePickerView = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 0
        picker.delegate = self
        picker.dataSource = self
    }

    private lazy var morningAfterPicker = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 1
        picker.delegate = self
        picker.dataSource = self
    }

    private lazy var timePicker = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 2
        picker.delegate = self
        picker.dataSource = self
    }

    private var separatorLabel = UILabel().then { label in
        label.font = .iosBody17Sb
        label.textColor = .primary
        label.text = ":"
    }

    private lazy var minutePicker = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 3
        picker.delegate = self
        picker.dataSource = self
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG45
    }

    private var buttonOk = UIButton().then { button in
        button.setTitle(L10n.EmailCertification.Modal.Button.yes, for: .normal)
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
            datePickerView,
            morningAfterPicker,
            timePicker,
            separatorLabel,
            minutePicker,
            hDivider,
            buttonOk,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }

        datePickerView.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(sheet.snp.leading).offset(35)
            make.height.equalTo(135)
            make.width.equalTo(80)
        }

        morningAfterPicker.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(datePickerView.snp.trailing).offset(24)
            make.height.equalTo(135)
            make.width.equalTo(43)
        }

        timePicker.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(morningAfterPicker.snp.trailing).offset(24)
            make.height.equalTo(135)
            make.width.equalTo(25)
        }

        separatorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timePicker.snp.centerY)
            make.leading.equalTo(timePicker.snp.trailing).offset(12)
        }

        minutePicker.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(separatorLabel.snp.trailing).offset(12)
            make.trailing.equalTo(sheet.snp.trailing).offset(-35)
            make.height.equalTo(135)
            make.width.equalTo(30)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(datePickerView.snp.bottom).offset(23)
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

// MARK: - PickerViewDelegate, PickerViewDataSource

extension SelectTimeModalViewController: PickerViewDelegate, PickerViewDataSource {
    func pickerViewHeightForRows(_: PickerView) -> CGFloat {
        30
    }

    func pickerView(_ picker: PickerView, titleForRow row: Int) -> String {
        switch picker.tag {
        case 0:
            return dayItem[row]
        case 1:
            return morningAfterNoon[row]
        case 2:
            return timeItem[row]
        case 3:
            return minuteItem[row]
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
            return dayItem.count
        case 1:
            return morningAfterNoon.count
        case 2:
            return timeItem.count
        case 3:
            return minuteItem.count
        default:
            return 0
        }
    }

    func pickerView(_: PickerView, didSelectRow _: Int) {
//        viewModel.inputs.itemSelected.onNext(didSelectRow)
    }
}
