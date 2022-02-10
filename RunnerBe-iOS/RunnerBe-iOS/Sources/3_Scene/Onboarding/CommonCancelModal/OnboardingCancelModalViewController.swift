//
//  OnboardingCancelModalViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/11.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class OnboardingCancelModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: OnboardingCancelModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: OnboardingCancelModalViewModel

    private func viewModelInput() {
        view.rx.tapGesture()
            .map { _ in }
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)
        
        buttonNo.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBags)
        
        buttonYes.rx.tap
            .bind(to: viewModel.inputs.tapYes)
            .disposed(by: disposeBags)
    }
    
    private func viewModelOutput() {}

    // MARK: private
    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
    }
    
    private var title1 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = L10n.Onboarding.Modal.Cancel.Message._1
        label.textAlignment = .left
    }
    
    private var title2 = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = L10n.Onboarding.Modal.Cancel.Message._2
        label.textAlignment = .left
    }
    
    private lazy var titleVStack = UIStackView.make(
        with: [title1, title2],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 2
    )
    
    private var buttonNo = UIButton().then { button in
        button.setTitle(L10n.Onboarding.Modal.Cancel.Button.no, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }
    
    private var buttonYes = UIButton().then { button in
        button.setTitle(L10n.Onboarding.Modal.Cancel.Button.yes, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }
    
}

// MARK: - Layout

extension OnboardingCancelModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet
        
        view.addSubviews([sheet])
        sheet.addSubviews([
            titleVStack,
            buttonNo,
            buttonYes,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(312)
            make.leading.equalTo(view.snp.leading).offset(53)
            make.trailing.equalTo(view.snp.trailing).offset(-53)
            make.height.equalTo(8 + 84 + 1 + 46 + 1 + 38 + 12)
        }
        
        titleVStack.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(24)
            make.leading.equalTo(sheet.snp.leading).offset(24)
            make.trailing.equalTo(sheet.snp.trailing).offset(-24)
        }
        
        buttonNo.snp.makeConstraints { make in
            make.top.equalTo(titleVStack.snp.bottom).offset(20)
            make.trailing.equalTo(sheet.snp.trailing).offset(-24)
        }
        
        buttonYes.snp.makeConstraints { make in
            make.top.equalTo(titleVStack.snp.bottom).offset(20)
            make.trailing.equalTo(buttonNo.snp.leading).offset(-24)
        }
    }
}
