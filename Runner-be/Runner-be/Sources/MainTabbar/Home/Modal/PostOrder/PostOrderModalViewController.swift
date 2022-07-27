//
//  PostOrderModalViewController.swift
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

class PostOrderModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: PostOrderModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: PostOrderModalViewModel

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

        distanceOrderButton.rx.tap
            .map { PostListOrder.distance }
            .bind(to: viewModel.inputs.tapOrder)

        latestOrderButton.rx.tap
            .map { PostListOrder.latest }
            .bind(to: viewModel.inputs.tapOrder)
    }

    private func viewModelOutput() {}

    private var sheet = UIView().then { view in
        view.backgroundColor = .darkG5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }

    private var distanceOrderButton = UIButton().then { button in
        button.setTitle("거리순", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody17R
    }

    private var latestOrderButton = UIButton().then { button in
        button.setTitle("최신순", for: .normal)
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
}

// MARK: - Layout

extension PostOrderModalViewController {
    private func setupViews() {
        view.backgroundColor = .bgSheet

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            distanceOrderButton,
            hDivider,
            latestOrderButton,
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(view.snp.width).offset(-100)
        }

        distanceOrderButton.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(52)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(distanceOrderButton.snp.bottom)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
        }

        latestOrderButton.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.top)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.bottom.equalTo(sheet.snp.bottom)
            make.height.equalTo(52)
        }
    }
}
