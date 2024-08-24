//
//  DetailSelectPlaceViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/23/24.
//

import UIKit

final class DetailSelectPlaceViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: DetailSelectPlaceViewModel

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.text = "Title"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold16
    }

    private let subTitleLabel = UILabel().then {
        $0.text = "SubTitle"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    private let editButton = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .darkG5
        $0.setTitle("주소 수정", for: .normal)
        $0.setTitleColor(.darkG2, for: .normal)
        $0.titleLabel?.font = .pretendardRegular12
    }

    // [START] Custom TextField
    private let customTextFieldView = UIView()
    private let textFieldContainerView = UIView().then {
        $0.layer.borderColor = UIColor.darkG5.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }

    private let textField = UITextField().then {
        let placeholderText = "모임 장소 상세 설명을 입력하세요."
        let placeholderFont = UIFont.pretendardRegular14
        let placeholderColor = UIColor.darkG35 // 원하는 색상으로 변경

        $0.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .font: placeholderFont,
                .foregroundColor: placeholderColor,
            ]
        )

        $0.font = .pretendardRegular14
        $0.textColor = .darkG35
        $0.tintColor = .primary
    }

    private let limitCountLabel = UILabel().then {
        $0.text = "0/35"
        $0.textColor = .darkG5
        $0.font = .pretendardRegular14
        $0.textAlignment = .right
    }

    // [END] Custom TextField

    private let registerButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .primary
        $0.setTitle("주소 등록", for: .normal)
        $0.setTitleColor(.darkG6, for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold15
    }

    private var navBar = RunnerbeNavBar().then {
        $0.titleLabel.text = L10n.Post.Place.NavBar.title
        $0.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
    }

    // MARK: - Init

    init(
        viewModel: DetailSelectPlaceViewModel
    ) {
        titleLabel.text = viewModel.placeInfo.title
        subTitleLabel.text = viewModel.placeInfo.subTitle
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

    // MARK: - Methods

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .debug()
            .bind(to: viewModel.routes.cancel)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}
}

// MARK: - Layout

extension DetailSelectPlaceViewController {
    private func setupViews() {
        setBackgroundColor()
        view.addSubviews([
            navBar,
            titleLabel,
            subTitleLabel,
            editButton,
            registerButton,
            customTextFieldView,
        ])

        customTextFieldView.addSubviews([
            textFieldContainerView,
            limitCountLabel,
        ])

        textFieldContainerView.addSubview(textField)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(16)
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel)
        }

        editButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(subTitleLabel)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }

        registerButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
            $0.height.equalTo(40)
        }

        customTextFieldView.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }

        textFieldContainerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }

        textField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        limitCountLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldContainerView.snp.bottom).offset(2)
            $0.left.right.equalToSuperview()
        }
    }
}
