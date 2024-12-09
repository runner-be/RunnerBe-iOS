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
        view.imageView.image = Asset.runnerBePlan.uiImage
    }

    private lazy var server = MakerView().then { view in
        view.roleLabel.text = "Server"
        view.nameLabel.text = "승완"
        view.imageView.image = Asset.runnerBeServer.uiImage
    }

    private lazy var design1 = MakerView().then { view in
        view.roleLabel.text = "Design"
        view.nameLabel.text = "정"
        view.imageView.image = Asset.runnerBeDesign1.uiImage
    }

    private lazy var design2 = MakerView().then { view in
        view.roleLabel.text = "Design"
        view.nameLabel.text = "쥬쥬"
        view.imageView.image = Asset.runnerBeDesign2.uiImage
    }

    private lazy var aos1 = MakerView().then { view in
        view.roleLabel.text = "AOS"
        view.nameLabel.text = "나이아카"
        view.imageView.image = Asset.runnerBeAOS1.uiImage
    }

    private lazy var aos2 = MakerView().then { view in
        view.roleLabel.text = "AOS"
        view.nameLabel.text = "로키"
        view.imageView.image = Asset.runnerBeAOS2.uiImage
    }

    private lazy var ios1 = MakerView().then { view in
        view.roleLabel.text = "iOS"
        view.nameLabel.text = "조이"
        view.imageView.image = Asset.runnerBeIOS1.uiImage
    }

    private lazy var ios2 = MakerView().then { view in
        view.roleLabel.text = "iOS"
        view.nameLabel.text = "창규"
        view.imageView.image = Asset.runnerBeIOS2.uiImage
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
            server,
            design1,
            design2,
            aos1,
            aos2,
            ios1,
            ios2,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        plan.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(server.snp.height)
            make.top.equalTo(navBar.snp.bottom).offset(24)
            make.right.equalTo(view.snp.centerX).offset(-30)
        }

        server.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(server.snp.height)
            make.top.equalTo(plan.snp.top)
            make.left.equalTo(view.snp.centerX).offset(30)
        }

        design1.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(design1.snp.height)
            make.top.equalTo(plan.snp.bottom).offset(32)
            make.leading.equalTo(plan.snp.leading)
        }

        design2.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(design2.snp.height)
            make.top.equalTo(design1.snp.top)
            make.leading.equalTo(server.snp.leading)
        }

        aos1.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(aos1.snp.height)
            make.top.equalTo(design1.snp.bottom).offset(32)
            make.leading.equalTo(plan.snp.leading)
        }

        aos2.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(aos2.snp.height)
            make.top.equalTo(aos1.snp.top)
            make.leading.equalTo(server.snp.leading)
        }

        ios1.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(ios1.snp.height)
            make.top.equalTo(aos1.snp.bottom).offset(32)
            make.leading.equalTo(plan.snp.leading)
        }

        ios2.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.14)
            make.width.equalTo(ios2.snp.height)
            make.top.equalTo(ios1.snp.top)
            make.leading.equalTo(server.snp.leading)
        }
    }
}
