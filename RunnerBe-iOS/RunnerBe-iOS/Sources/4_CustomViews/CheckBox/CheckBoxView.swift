//
//  CheckBoxView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit

final class CheckBoxView: UIStackView {
    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        bindInput()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var disposeBag = DisposeBag()
    var tapCheck = PublishSubject<Bool>()
    var tapDetail = PublishSubject<Void>()
    var leftBox = true {
        didSet {
            checkBoxButton.removeFromSuperview()
            titleLabel.removeFromSuperview()
            moreInfoButton.removeFromSuperview()
            if leftBox {
                addArrangedSubviews([checkBoxButton, titleLabel, moreInfoButton])
            } else {
                addArrangedSubviews([titleLabel, checkBoxButton, moreInfoButton])
            }
        }
    }

    var showMoreInfo = true

    var checkBoxButton = UIButton().then { button in
        button.setImage(Asset.checkBoxIconEmpty.uiImage.withTintColor(.darkG35), for: .normal)
        button.setImage(Asset.checkBoxIconChecked.uiImage.withTintColor(.primary), for: .selected)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.backgroundColor = .clear
        button.isSelected = false
    }

    var titleLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = ""
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.backgroundColor = .clear
    }

    lazy var moreInfoButton = UIButton().then { button in
        button.setImage(Asset.chevronRight.uiImage.withTintColor(.darkG35), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    var labelText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var isSelected: Bool {
        get { checkBoxButton.isSelected }
        set {
            checkBoxButton.isSelected = newValue
            tapCheck.onNext(newValue)
        }
    }

    // MARK: Private

    private func bindInput() {
        checkBoxButton.rx.tap
            .map {
                self.checkBoxButton.isSelected.toggle()
                return self.checkBoxButton.isSelected
            }
            .subscribe(tapCheck)
            .disposed(by: disposeBag)

        titleLabel.rx.tapGesture()
            .map { _ in
                self.checkBoxButton.isSelected.toggle()
                return self.checkBoxButton.isSelected
            }
            .subscribe(tapCheck)
            .disposed(by: disposeBag)

        moreInfoButton.rx.tap
            .subscribe(tapDetail)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension CheckBoxView {
    private func setupViews() {
        alignment = .center
        distribution = .fill
        if leftBox {
            addArrangedSubviews([checkBoxButton, titleLabel, moreInfoButton])
        } else {
            addArrangedSubviews([titleLabel, checkBoxButton, moreInfoButton])
        }
    }

    private func initialLayout() {}
}
