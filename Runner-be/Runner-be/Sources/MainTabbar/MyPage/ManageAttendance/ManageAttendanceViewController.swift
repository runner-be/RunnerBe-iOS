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
import Toast_Swift
import UIKit

class ManageAttendanceViewController: BaseViewController {
    var useCornerRadiusAsRatio: Bool = true
    var cornerRadiusFactor: CGFloat = 1
    var myRunningIdx = -1 // 출석관리하기의 runnerList를 가져올 idx
    var attendTimeOver = "N"
    lazy var manageAttendanceDataManager = ManageAttendanceDataManager()
    var runnerList: [RunnerList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()

        manageAttendanceDataManager.getManageAttendance(viewController: self)

        tableView.delegate = self
        tableView.dataSource = self
    }

    init(viewModel: ManageAttendanceViewModel, myRunningIdx: Int) {
        self.viewModel = viewModel
        self.myRunningIdx = myRunningIdx

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
        view.register(ManageAttendanceCell.self, forCellReuseIdentifier: ManageAttendanceCell.id) // 케이스에 따른 셀을 모두 등록
        view.separatorStyle = .none
        view.backgroundColor = .black
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.backgroundColor = .darkG7
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
//        setBackgroundColor()
        view.backgroundColor = .black

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

//        timeView.snp.makeConstraints { make in
//            make.top.equalTo(navBar.snp.bottom)
//            make.leading.equalTo(view.snp.leading)
//            make.trailing.equalTo(view.snp.trailing)
//            make.height.equalTo(44)
//        }

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

extension ManageAttendanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return runnerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageAttendanceCell.id) as? ManageAttendanceCell else { return .init() }

        let user = User(userID: runnerList[indexPath.row].userID!, nickName: runnerList[indexPath.row].nickName!, gender: runnerList[indexPath.row].gender!, age: runnerList[indexPath.row].age!, diligence: runnerList[indexPath.row].diligence!, pushOn: "Y", job: runnerList[indexPath.row].job!, profileImageURL: runnerList[indexPath.row].profileImageURL!)
        var isUser = false

        if runnerList[indexPath.row].whetherPostUser == "Y" {
            isUser = true
        } else {
            isUser = false
        }

        if runnerList[indexPath.row].whetherCheck! == "Y" { // 리더가 출석체크했음
            if runnerList[indexPath.row].attendance! == 0 {
                cell.resultView.label.text = L10n.MyPage.ManageAttendance.Absence.title
            } else {
                cell.resultView.label.text = L10n.MyPage.ManageAttendance.Attendance.title
            }
        } else {
            cell.resultView.label.text = L10n.MyPage.ManageAttendance.Before.title
        }
        
//        if attendTimeOver! == "Y" { //출석관리 마감시간 여부
////            cell.
//        }

        cell.configure(userInfo: UserConfig(from: user, owner: isUser))

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return CGFloat(176)
    }
}

extension ManageAttendanceViewController {
    func didSuccessGetManageAttendance(result: GetMyPageResult) {
//        print("출석 여부: \(result.myPosting?[myRunningIdx].attendTimeOver)")
        runnerList.append(contentsOf: result.myPosting?[myRunningIdx].runnerList ?? [])

        tableView.reloadData()

        if result.myPosting?[myRunningIdx].attendTimeOver! == "Y" { // 출석 관리 마감 여부
            attendTimeOver = "Y"
            navBar.titleLabel.text = L10n.MyPage.MyPost.Manage.Finished.title
            saveButton.isHidden = true
        } else { // 출석이 완료되지 않을 경우
            attendTimeOver = "N"
            navBar.titleLabel.text = L10n.MyPage.MyPost.Manage.After.title
            saveButton.isHidden = false
        }
    }

    func didSuccessPatchAttendance(_: BaseResponse) {}

    func failedToRequest(message: String) {
        print(message)
    }
}
