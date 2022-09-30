//
//  SelectGenderViewController.swift
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

final class SelectGenderViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SelectGenderViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: SelectGenderViewModel

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

        genderLabelGroup.tap
            .compactMap { $0 }
            .map { [weak self] numSelected in
                guard let self = self else { return [] }
                return (numSelected != 0) ? self.genderLabelGroup.selected : []
            }
            .bind(to: viewModel.inputs.tapGroup)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: { [weak self] enable in
                self?.nextButton.isEnabled = enable
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.attributedText = NSMutableAttributedString()
            .style(to: "3", attributes: [
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
        label.setTextWithLineHeight(text: L10n.Onboarding.Gender.title, with: 42)
        label.textColor = .primary
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var femaleLabel = OnOffLabel().then { label in
        label.text = L10n.Gender.female
    }

    private var malelabel = OnOffLabel().then { label in
        label.text = L10n.Gender.male
    }

    private var genderLabelGroup = OnOffLabelGroup().then { group in
        group.styleOn = OnOffLabel.Style(
            font: .iosBody15B,
            backgroundColor: .primary,
            textColor: .darkG6,
            borderWidth: 1,
            borderColor: .primary,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 8, left: 19, bottom: 10, right: 19)
        )

        group.styleOff = OnOffLabel.Style(
            font: .iosBody15B,
            backgroundColor: .clear,
            textColor: .darkG35,
            borderWidth: 1,
            borderColor: .darkG35,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 8, left: 19, bottom: 10, right: 19)
        )

        group.maxNumberOfOnState = 1
    }

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.Onboarding.Gender.Button.next, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.Onboarding.Gender.Button.next, for: .disabled)
        button.setTitleColor(UIColor.darkG4, for: .disabled)
        button.setBackgroundColor(UIColor.darkG5, for: .disabled)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true

        button.isEnabled = false
    }
}

// MARK: - Layout

extension SelectGenderViewController {
    private func setupViews() {
        view.backgroundColor = .darkG7

        view.addSubviews([
            navBar,
            titleLabel,

            femaleLabel,
            malelabel,

            nextButton,
        ])
        genderLabelGroup.append(labels: [femaleLabel, malelabel])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(26)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-104)
        }

        femaleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(106)
            make.trailing.equalTo(view.snp.centerX).offset(-8)
        }

        malelabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(106)
            make.leading.equalTo(view.snp.centerX).offset(8)
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
