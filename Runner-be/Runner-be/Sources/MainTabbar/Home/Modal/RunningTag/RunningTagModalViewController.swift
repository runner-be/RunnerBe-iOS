//
//  RunningTagModalViewController.swift
//  Runner-be
//
//  Created by 김신우 on 2022/07/27.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class RunningTagModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: RunningTagModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: RunningTagModalViewModel

    private func viewModelInput() {
        sheet.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)

        view.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .map { _ in }
        .subscribe(viewModel.inputs.backward)
        .disposed(by: disposeBag)

        allButton.rx.tap
            .map { RunningTag.all }
            .bind(to: viewModel.inputs.tapOrder)
            .disposed(by: disposeBag)

        afterWorkButton.rx.tap
            .map { RunningTag.afterWork }
            .bind(to: viewModel.inputs.tapOrder)
            .disposed(by: disposeBag)

        beforeWorkButton.rx.tap
            .map { RunningTag.beforeWork }
            .bind(to: viewModel.inputs.tapOrder)
            .disposed(by: disposeBag)

        dayOffButton.rx.tap
            .map { RunningTag.dayoff }
            .bind(to: viewModel.inputs.tapOrder)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
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

    private var allButton = UIButton().then { button in
        button.setTitle("전체", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }

    private var hDivider3 = UIView().then { view in
        view.backgroundColor = .darkG45
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var beforeWorkButton = UIButton().then { button in
        button.setTitle("출근 전", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG45
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var afterWorkButton = UIButton().then { button in
        button.setTitle("퇴근 후", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }

    private var hDivider2 = UIView().then { view in
        view.backgroundColor = .darkG45
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var dayOffButton = UIButton().then { button in
        button.setTitle("휴일", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }
}

// MARK: - Layout

extension RunningTagModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            allButton,
            hDivider3,
            beforeWorkButton,
            hDivider,
            afterWorkButton,
            hDivider2,
            dayOffButton,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(view.snp.width).offset(-100)
        }

        allButton.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(52)
        }

        hDivider3.snp.makeConstraints { make in
            make.top.equalTo(allButton.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        beforeWorkButton.snp.makeConstraints { make in
            make.top.equalTo(hDivider3.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(52)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(beforeWorkButton.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        afterWorkButton.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(46)
        }

        hDivider2.snp.makeConstraints { make in
            make.top.equalTo(afterWorkButton.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        dayOffButton.snp.makeConstraints { make in
            make.top.equalTo(hDivider2.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
            make.height.equalTo(52)
        }
    }
}
