//
//  SelectDateBottomSheetViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import PickerView
import UIKit

final class SelectDateBottomSheetViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: SelectDateBottomSheetViewModel

    private var years: [Int] = []
    private var months: [String] = []

    private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    // MARK: - UI

    private let backgroundView = UIView()

    private let bottomSheetBg = UIView().then {
        $0.backgroundColor = .darkG55
        $0.layer.cornerRadius = 12
    }

    private let bottomHandle = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 1.5
    }

    private lazy var yearPickerView = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 0
        picker.delegate = self
        picker.dataSource = self
    }

    private lazy var monthPickerView = PickerView().then { picker in
        picker.scrollingStyle = .default
        picker.selectionStyle = .none
        picker.backgroundColor = .clear
        picker.tag = 0
        picker.delegate = self
        picker.dataSource = self
    }

    private let confirmButton = UIButton().then {
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 24
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold15
        $0.setTitleColor(.darkG6, for: .normal)
    }

    // MARK: - Init

    init(viewModel: SelectDateBottomSheetViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBottomSheet()
    }

    // MARK: - Methods

    private func viewModelInput() {
        backgroundView.rx.tapGesture()
            .map { _ in }
            .bind(to: viewModel.routes.cancel)
            .disposed(by: disposeBag)

        confirmButton.rx.tap
            .bind(to: viewModel.inputs.selectDate)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        yearPickerView.selectRow(viewModel.inputs.yearSelected, animated: false)
        monthPickerView.selectRow(viewModel.inputs.monthSelected, animated: false)
    }

    private func animateBottomSheet() {
        // Update the constraint to animate the bottom sheet coming up
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.bottomSheetBg.snp.updateConstraints {
                $0.top.equalTo(self.view.snp.bottom).offset(-320)
            }
            self.view.layoutIfNeeded()
        })
    }

    private func setupYearAndMonthData() {
        // Setup year array (e.g., from 2000 to the current year + 10)
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(2000 ... currentYear + 10)

        // Setup month array
        months = Calendar.current.monthSymbols
    }
}

// MARK: - PickerViewDataSource

extension SelectDateBottomSheetViewController: PickerViewDelegate, PickerViewDataSource {
    func pickerViewHeightForRows(_: PickerView) -> CGFloat {
        return 40
    }

    func pickerViewNumberOfRows(_ picker: PickerView) -> Int {
        switch picker {
        case let c where c == yearPickerView:
            return viewModel.outputs.yearItems.count
        case let c where c == monthPickerView:
            return viewModel.outputs.monthItems.count
        default:
            return 0
        }
    }

    func pickerView(_ picker: PickerView, titleForRow row: Int) -> String {
        switch picker {
        case let c where c == yearPickerView:
            return viewModel.outputs.yearItems[row]
        case let c where c == monthPickerView:
            return viewModel.outputs.monthItems[row]
        default:
            return ""
        }
    }

    func pickerView(_: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if highlighted {
            label.font = .pretendardSemiBold20
            label.textColor = .primarydark
        } else {
            label.font = .pretendardRegular18
            label.textColor = .darkG4
        }
    }

    func pickerView(_ picker: PickerView, didSelectRow: Int) {
        switch picker {
        case let c where c == yearPickerView:
            viewModel.inputs.yearSelected = didSelectRow
        case let c where c == monthPickerView:
            viewModel.inputs.monthSelected = didSelectRow
        default:
            return
        }
    }
}

// MARK: - Layout

extension SelectDateBottomSheetViewController {
    private func setupViews() {
        view.addSubviews([
            backgroundView,
            bottomSheetBg,
        ])

        bottomSheetBg.addSubviews([
            bottomHandle,
            yearPickerView,
            monthPickerView,
            confirmButton,
        ])
    }

    private func initialLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }

        bottomSheetBg.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.snp.bottom)
            $0.height.equalTo(320)
        }

        bottomHandle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(37)
            $0.height.equalTo(3)
        }

        yearPickerView.snp.makeConstraints {
            $0.top.equalTo(bottomHandle.snp.bottom).offset(8)
            $0.centerX.equalToSuperview().offset(-UIScreen.main.bounds.width / 4)
            $0.width.equalTo(96)
            $0.height.equalTo(200)
        }

        monthPickerView.snp.makeConstraints {
            $0.top.equalTo(bottomHandle.snp.bottom).offset(8)
            $0.centerX.equalToSuperview().offset(UIScreen.main.bounds.width / 4)
            $0.width.equalTo(86)
            $0.height.equalTo(200)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(yearPickerView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
}
