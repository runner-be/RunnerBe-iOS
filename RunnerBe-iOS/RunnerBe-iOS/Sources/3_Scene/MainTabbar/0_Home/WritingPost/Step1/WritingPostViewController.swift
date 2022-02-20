//
//  WritingPostViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class WritingPostViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: WritingPostViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WritingPostViewModel

    private func viewModelInput() {
        writeDateView.contentView.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }).when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.editDate)
            .disposed(by: disposeBags)

        writeTimeView.contentView.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }).when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.editTime)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        viewModel.outputs.date
            .bind(to: writeDateView.contentText)
            .disposed(by: disposeBags)

        viewModel.outputs.time
            .bind(to: writeTimeView.contentText)
            .disposed(by: disposeBags)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = ""
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)

        navBar.rightBtnItem.setTitle(L10n.NavBar.Right.First.next, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
        navBar.rightBtnItem.titleLabel?.font = .iosBody17R
        navBar.rightSecondBtnItem.isHidden = false
    }

    private var segmentedControl = SegmentedControl().then { control in

        control.defaultTextFont = .iosBody15R
        control.defaultTextColor = .darkG45
        control.highlightTextFont = .iosBody15B
        control.highlightTextColor = .darkG5
        control.fontSize = 15
        control.boxColors = [.darkG6]
        control.highlightBoxColors = [.segmentBgTop, .segmentBgBot]
        control.highlightBoxPadding = .zero
        control.boxPadding = UIEdgeInsets(top: 6, left: 0, bottom: 8, right: 0)

        control.items = [
            L10n.Post.WorkTime.afterWork,
            L10n.Post.WorkTime.beforeWork,
            L10n.Post.WorkTime.dayOff,
        ]
    }

    private var scrollView = UIScrollView().then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
    }

    private var writeTitleView = WritingTitleView()
    private var hDivider1 = UIView().then { $0.backgroundColor = .darkG6 }
    private var writeDateView = WritingDateView()
    private var hDivider2 = UIView().then { $0.backgroundColor = .darkG6 }
    private var writeTimeView = WritingTimeView()
    private var hDivider3 = UIView().then { $0.backgroundColor = .darkG6 }
    private var writePlaceView = WritingPlaceView()

    private lazy var vStackView = UIStackView.make(
        with: [
            writeTitleView,
            hDivider1,
            writeDateView,
            hDivider2,
            writeTimeView,
            hDivider3,
            writePlaceView,
        ],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 12
    )
}

// MARK: - Layout

extension WritingPostViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            segmentedControl,
            scrollView,
        ])

        scrollView.addSubview(vStackView)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide
                .snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(18)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
        }

        hDivider1.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(1)
        }
        hDivider2.snp.makeConstraints { make in
//            make.leading.equalTo(vStackView.snp.leading)
//            make.trailing.equalTo(vStackView.snp.trailing)
            make.height.equalTo(1)
        }
        hDivider3.snp.makeConstraints { make in
//            make.leading.equalTo(vStackView.snp.leading)
//            make.trailing.equalTo(vStackView.snp.trailing)
            make.height.equalTo(1)
        }
    }

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.bgBottom.cgColor,
            UIColor.bgTop.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
