//
//  MakerViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

final class MakerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MakerViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MakerViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {}

    private var plan = MakerView().then { view in
        view.roleLabel.text = "PLAN"
        view.nameLabel.text = "김은서"
        view.imageView.image = Asset.runnerBePLAN.uiImage
    }

    private var design = MakerView().then { view in
        view.roleLabel.text = "DESIGN"
        view.nameLabel.text = "김서정"
        view.imageView.image = Asset.runnerBeDESIGN.uiImage
    }

    private var aos = MakerView().then { view in
        view.roleLabel.text = "AOS"
        view.nameLabel.text = "지성빈"
        view.imageView.image = Asset.runnerBeAOS.uiImage
    }

    private var ios = MakerView().then { view in
        view.roleLabel.text = "iOS"
        view.nameLabel.text = "김신우"
        view.imageView.image = Asset.runnerBeIOS.uiImage
    }

    private var server = MakerView().then { view in
        view.roleLabel.text = "SERVER"
        view.nameLabel.text = "박찬호"
        view.imageView.image = Asset.runnerBeServer.uiImage
    }

    private lazy var vStack = UIStackView.make(
        with: [plan, design, aos, ios, server],
        axis: .vertical,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 40
    )

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MyPage.Maker.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.titleLabel.font = .iosBody17Sb
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension MakerViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            vStack,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        vStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
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
