//
//  ConfirmModalViewController.swift
//  Runner-be
//
//  Created by 이유리 on 2/16/24.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

final class ConfirmModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: ConfirmModalViewModel, pace: String) {
        self.viewModel = viewModel
        self.pace = RunningPace(rawValue: pace)
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: ConfirmModalViewModel
    private var pace: RunningPace?

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
        .subscribe(viewModel.inputs.cancel)
        .disposed(by: disposeBag)

        buttonOk.rx.tap
            .bind(to: viewModel.inputs.ok)
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
        view.backgroundColor = .darkG45
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        view.snp.makeConstraints { make in
            make.height.equalTo(292)
        }
    }

    private var imageView = UIImageView().then { view in
        view.image = .whiteCircleBackground
        view.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
    }

    private var subImageView = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }

    private var titleLabel = UILabel().then { label in
        label.font = .pretendardSemiBold18
        label.textColor = .darkG1
        label.text = "페이스 \(L10n.RunningPace.Beginner.title)\n등록 완료!"
        label.numberOfLines = 2
        label.textAlignment = .center
    }

    private var subTitleLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG25
        label.text = "페이스는 언제든 수정할 수 있어요."
        label.numberOfLines = 1
        label.textAlignment = .center
    }

    private var buttonOk = UIButton().then { button in
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.darkG6, for: .normal)
        button.setBackgroundColor(.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 24

        button.titleLabel?.font = .pretendardSemiBold16
    }
}

// MARK: - Layout

extension ConfirmModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            titleLabel,
            subTitleLabel,
            imageView,
            buttonOk,
        ])

        imageView.addSubview(subImageView)

        if let pace = pace {
            switch pace {
            case .beginner:
                subImageView.image = .runningPaceBeginner
            case .average:
                subImageView.image = .runningPaceAverage
            case .high:
                subImageView.image = .runningPaceHigh
            case .master:
                subImageView.image = .runningPaceMaster
            case .none:
                break
            }
            titleLabel.text = "페이스 \(pace.value)\n등록 완료!"
        }
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.centerY.equalTo(view.snp.centerY)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(43)
            make.centerX.equalToSuperview()
        }

        subImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        buttonOk.snp.makeConstraints { make in
            make.leading.equalTo(sheet.snp.leading).offset(16)
            make.trailing.equalTo(sheet.snp.trailing).offset(-16)
            make.bottom.equalTo(sheet.snp.bottom).offset(-16)
            make.height.equalTo(40)
        }
    }
}
