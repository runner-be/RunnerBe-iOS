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
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private lazy var plan = MakerView().then { view in
        view.roleLabel.text = "Plan"
        view.nameLabel.text = "은서"
        view.imageView.image = Asset.runnerBePLAN.uiImage
    }

    private lazy var design = MakerView().then { view in
        view.roleLabel.text = "Design"
        view.nameLabel.text = "정"
        view.imageView.image = Asset.runnerBeDESIGN.uiImage
    }

    private lazy var aos_niaka = MakerView().then { view in
        view.roleLabel.text = "AOS"
        view.nameLabel.text = "나이아카"
        view.imageView.image = Asset.runnerBeNiaka.uiImage
    }

    private lazy var aos_judy = MakerView().then { view in
        view.roleLabel.text = "AOS"
        view.nameLabel.text = "주디"
        view.imageView.image = Asset.runnerBeJudy.uiImage
    }

    private lazy var ios_shiv = MakerView().then { view in
        view.roleLabel.text = "iOS"
        view.nameLabel.text = "시브"
        view.imageView.image = Asset.runnerBeSiv.uiImage
    }

    private lazy var ios_zoe = MakerView().then { view in
        view.roleLabel.text = "iOS"
        view.nameLabel.text = "조이"
        view.imageView.image = Asset.runnerBeZoe.uiImage
    }

    private lazy var server = MakerView().then { view in
        view.roleLabel.text = "Server"
        view.nameLabel.text = "찬호"
        view.imageView.image = Asset.runnerBeServer.uiImage
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MyPage.Maker.NavBar.title
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension MakerViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            plan,
            design,
            aos_niaka,
            aos_judy,
            ios_shiv,
            ios_zoe,
            server,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        plan.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(plan.snp.height)
            make.top.equalTo(navBar.snp.bottom).offset(40)
            make.leading.equalTo(view.snp.leading).offset(view.bounds.width * 0.194)
        }

        design.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(design.snp.height)
            make.top.equalTo(plan.snp.top)
            make.trailing.equalTo(view.snp.trailing).offset(-view.bounds.width * 0.194)
        }

        aos_niaka.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(aos_niaka.snp.height)
            make.top.equalTo(plan.snp.bottom).offset(43)
            make.leading.equalTo(plan.snp.leading)
        }

        aos_judy.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(aos_judy.snp.height)
            make.top.equalTo(aos_niaka.snp.top)
            make.leading.equalTo(design.snp.leading)
        }

        ios_shiv.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(ios_shiv.snp.height)
            make.top.equalTo(aos_niaka.snp.bottom).offset(43)
            make.leading.equalTo(plan.snp.leading)
        }

        ios_zoe.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(ios_zoe.snp.height)
            make.top.equalTo(ios_shiv.snp.top)
            make.leading.equalTo(design.snp.leading)
        }

        server.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(server.snp.height)
            make.top.equalTo(ios_shiv.snp.bottom).offset(43)
            make.leading.equalTo(plan.snp.leading)
        }
    }
}
