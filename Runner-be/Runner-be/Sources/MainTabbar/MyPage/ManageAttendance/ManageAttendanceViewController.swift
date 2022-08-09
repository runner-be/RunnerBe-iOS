//
//  ManageAttendanceViewController.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

// 출석 관리하기 화면
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SafariServices
import SnapKit
import Then
import UIKit

class ManageAttendanceViewController: BaseViewController {
    var useCornerRadiusAsRatio: Bool = true
    var cornerRadiusFactor: CGFloat = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()

//        tableView.delegate = self
//        tableView.dataSource = self
    }

    init(viewModel: ManageAttendanceViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: ManageAttendanceViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {}

    private var tableView = UITableView().then { view in
        view.backgroundColor = .clear
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MyPage.MyPost.Manage.After.title
        navBar.titleLabel.textColor = .darkG35
        navBar.titleLabel.font = .iosBody17Sb
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var timeView = UIView().then { view in
        view.backgroundColor = .darkG6
        view.isHidden = true
    }

    private var saveButton = UIButton().then { view in
        view.backgroundColor = .primary
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .iosBody13B
        view.setTitle(L10n.MyPage.MyPost.Manage.SaveButton.title, for: .normal)
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
}

// layout
extension ManageAttendanceViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            timeView,
            tableView,
            saveButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        timeView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(44)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(saveButton.snp.top).offset(8)
        }

        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(8)
        }
    }
}

// extension ManageAttendanceViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: <#T##IndexPath#>)
//    }
//
// }
