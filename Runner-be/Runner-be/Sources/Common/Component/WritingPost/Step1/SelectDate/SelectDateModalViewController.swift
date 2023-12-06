//
//  SelectDateModalViewController.swift
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

class SelectDateModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SelectDateModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: SelectDateModalViewModel

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
        datePickerView.selectRow(viewModel.inputs.dateSelected, animated: false)
        morningAfterPicker.selectRow(viewModel.inputs.ampmSelected, animated: false)
        timePicker.selectRow(viewModel.inputs.timeSelected, animated: false)
        minutePicker.selectRow(viewModel.inputs.minuteSelected, animated: false)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

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
        button.setTitle(L10n.Modal.SelectDate.Button.ok, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)

        button.titleLabel?.font = .iosBody17R
    }
}

extension SelectDateModalViewController {
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
            make.height.equalTo(120)
            make.width.equalTo(90)
        }

        morningAfterPicker.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(datePickerView.snp.trailing).offset(24)
            make.height.equalTo(datePickerView.snp.height)
            make.width.equalTo(43)
        }

        timePicker.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(morningAfterPicker.snp.trailing).offset(24)
            make.height.equalTo(datePickerView.snp.height)
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
            make.height.equalTo(datePickerView.snp.height)
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

extension SelectDateModalViewController: PickerViewDelegate, PickerViewDataSource {
    func pickerViewHeightForRows(_: PickerView) -> CGFloat {
        30
    }

    func pickerView(_ picker: PickerView, titleForRow row: Int) -> String {
        switch picker.tag {
        case 0:
            return viewModel.outputs.dateItems[row]
        case 1:
            return viewModel.outputs.ampmItems[row]
        case 2:
            return viewModel.outputs.timeItems[row]
        case 3:
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
            return viewModel.outputs.dateItems.count
        case 1:
            return viewModel.outputs.ampmItems.count
        case 2:
            return viewModel.outputs.timeItems.count
        case 3:
            return viewModel.outputs.minuteItems.count
        default:
            return 0
        }
    }

    func pickerView(_ picker: PickerView, didSelectRow: Int) {
        switch picker.tag {
        case 0:
            viewModel.inputs.dateSelected = didSelectRow
        case 1:
            viewModel.inputs.ampmSelected = didSelectRow
        case 2:
            viewModel.inputs.timeSelected = didSelectRow
        case 3:
            viewModel.inputs.minuteSelected = didSelectRow
        default: break
        }
    }
}
