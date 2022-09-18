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
    var postId = -1
    var attendTimeOver = "N"
    var runnerList: [RunnerList] = []
    var userList: [Int] = []
    var attendList: [String] = []

    lazy var manageAttendanceDataManager = ManageAttendanceDataManager()

    let currentDate = DateUtil.shared.now
    var gatherDate = Date()
    var runningTime = TimeInterval()
    var time = 0
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        manageAttendanceDataManager.getManageAttendance(viewController: self)

        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()

        tableView.delegate = self
        tableView.dataSource = self

        saveButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if !self.attendList.contains("-") { // 모두 출석체크되었으면
                    print(self.userList.description)
                    print(self.attendList.description)
                    self.manageAttendanceDataManager.patchAttendance(viewController: self, postId: self.postId, userIdList: self.userList.map(String.init).joined(separator: ","), whetherAttendList: self.attendList.joined(separator: ","))
                }
            })
            .disposed(by: disposeBag)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
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

    @objc func timerCallback() {
        time -= 1
        timeSecondLabel.text = "\(Int(time / (60 * 60)))시간 \(Int(time / 60))분"

        if time == 0 {
            timer?.invalidate()
            viewModel.inputs.showExpiredModal.onNext(())
        }
    }

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

    private var timeFirstLabel = UILabel().then { view in
        view.textColor = .darkG25
        view.font = .iosBody13B
        view.text = L10n.MyPage.MyPost.Manage.TimeGuide.Content.first
    }

    var timeSecondLabel = UILabel().then { view in
        view.textColor = .primary
        view.font = .iosBody13B
    }

    private var timeThirdLabel = UILabel().then { view in
        view.textColor = .darkG25
        view.font = .iosBody13B
        view.text = L10n.MyPage.MyPost.Manage.TimeGuide.Content.second
    }

    private var saveButton = UIButton().then { view in
        view.backgroundColor = .primary
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .iosBody15B
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
            timeFirstLabel,
            timeSecondLabel,
            timeThirdLabel,
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

        timeFirstLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeView.snp.leading).offset(18)
            make.centerY.equalTo(timeView.snp.centerY)
        }

        timeSecondLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeFirstLabel.snp.trailing).offset(2)
            make.centerY.equalTo(timeView.snp.centerY)
        }

        timeThirdLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeSecondLabel.snp.trailing).offset(2)
            make.centerY.equalTo(timeView.snp.centerY)
        }

        tableView.snp.makeConstraints { make in
//            if timeView.isHidden {
//                make.top.equalTo(view.snp.bottom)
//            } else {
            make.top.equalTo(timeView.snp.bottom)
//            }
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
        cell.selectionStyle = .none

        // user 세팅하기
        let user = User(userID: runnerList[indexPath.row].userID!, nickName: runnerList[indexPath.row].nickName!, gender: runnerList[indexPath.row].gender!, age: runnerList[indexPath.row].age!, diligence: runnerList[indexPath.row].diligence!, pushOn: "Y", job: runnerList[indexPath.row].job!, profileImageURL: runnerList[indexPath.row].profileImageURL!)
        var isUser = false

        if runnerList[indexPath.row].whetherPostUser == "Y" {
            isUser = true
        } else {
            isUser = false
        }

        cell.configure(userInfo: UserConfig(from: user, owner: isUser))

        // 출석관리하기 버튼 / 결과값 여부
        if attendTimeOver == "Y" { // 출석관리 마감시간 여부
            timeView.isHidden = true
            cell.resultView.isHidden = false
            cell.refusalBtn.isHidden = true
            cell.acceptBtn.isHidden = true

            if runnerList[indexPath.row].whetherCheck! == "Y" { // 리더가 출석체크했음
                if runnerList[indexPath.row].attendance! == 0 {
                    cell.resultView.label.text = L10n.MyPage.ManageAttendance.Absence.title
                } else {
                    cell.resultView.label.text = L10n.MyPage.ManageAttendance.Attendance.title
                }
            } else {
                cell.resultView.label.text = L10n.MyPage.ManageAttendance.Before.title
            }
        } else {
            timeView.isHidden = false
            cell.resultView.isHidden = true
            cell.refusalBtn.isHidden = false
            cell.acceptBtn.isHidden = false

            cell.refusalBtn.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    if !cell.refusalBtn.isSelected { // 비활성 -> 활성
                        cell.refusalBtn.isSelected = true
                        cell.refusalBtn.backgroundColor = .primary
                        cell.refusalBtn.setTitleColor(.black, for: .selected)

                        cell.acceptBtn.isSelected = false
                        cell.acceptBtn.backgroundColor = .clear
                        cell.acceptBtn.setTitleColor(.darkG3, for: .normal)

                        self.attendList[indexPath.row] = "N"

                    } else { // 활성 -> 비활성
                        cell.refusalBtn.isSelected = false
                        cell.refusalBtn.backgroundColor = .clear
                        cell.refusalBtn.setTitleColor(.darkG3, for: .normal)

                        self.attendList[indexPath.row] = "-"
                    }

                })
                .disposed(by: disposeBag)

            cell.acceptBtn.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    if !cell.acceptBtn.isSelected { // 비활성 -> 활성
                        cell.acceptBtn.isSelected = true
                        cell.acceptBtn.backgroundColor = .primary
                        cell.acceptBtn.setTitleColor(.black, for: .selected)

                        cell.refusalBtn.isSelected = false
                        cell.refusalBtn.backgroundColor = .clear
                        cell.refusalBtn.setTitleColor(.darkG3, for: .normal)

                        self.attendList[indexPath.row] = "Y"

                    } else { // 활성 -> 비활성
                        cell.acceptBtn.isSelected = false
                        cell.acceptBtn.backgroundColor = .clear
                        cell.acceptBtn.setTitleColor(.darkG3, for: .normal)

                        self.attendList[indexPath.row] = "-"
                    }

                })
                .disposed(by: disposeBag)
        }

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

            timeView.isHidden = true
            timeFirstLabel.isHidden = true
            timeSecondLabel.isHidden = true
            timeThirdLabel.isHidden = true

            tableView.snp.makeConstraints { make in
                make.top.equalTo(navBar.snp.bottom)
                //            }
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
                make.bottom.equalTo(saveButton.snp.top).offset(8)
            }
        } else { // 출석이 완료되지 않을 경우
            attendTimeOver = "N"
            navBar.titleLabel.text = L10n.MyPage.MyPost.Manage.After.title
            saveButton.isHidden = false

            timeView.isHidden = false
            timeFirstLabel.isHidden = false
            timeSecondLabel.isHidden = false
            timeThirdLabel.isHidden = false

            tableView.snp.makeConstraints { make in
                //            if timeView.isHidden {
                //                make.top.equalTo(view.snp.bottom)
                //            } else {
                make.top.equalTo(timeView.snp.bottom)
                //            }
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
                make.bottom.equalTo(saveButton.snp.top).offset(8)
            }
        }

        postId = (result.myPosting?[myRunningIdx].postID)!

        let formatter = DateUtil.shared.dateFormatter
        formatter.dateFormat = DateFormat.apiDate.formatString
        // <<<<<<< Updated upstream
        let dateString = (result.myPosting?[myRunningIdx].gatheringTime!)!
        print("dateString : \(dateString)")
        gatherDate = DateUtil.shared.apiDateStringToDate(dateString)!
//        gatherDate = formatter.date(from: (result.myPosting?[myRunningIdx].gatheringTime!)!)! // 러닝 시작 날짜
        //=======
//        gatherDate = formatter.date(from: (result.myPosting?[myRunningIdx].gatheringTime!)!)! // 러닝 시작 날짜
//        gatherDate = gatherDate.addingTimeInterval(TimeInterval(-TimeZone.current.secondsFromGMT()))
        // >>>>>>> Stashed changes

        let hms = result.myPosting?[myRunningIdx].runningTime!.components(separatedBy: ":") // hour miniute seconds
        let hour = Int(hms![0])
        let minute = Int(hms![1])

        print("runningTime: \(hour):\(minute)")

//        runningInterval = TimeInterval(hour! * 60 * 60 + minute! * 60)

        print("gatherDate \(gatherDate.addingTimeInterval(TimeInterval(9 * 60 * 60)))")
        var finishedDate = gatherDate.addingTimeInterval(TimeInterval((hour! + 3) * 60 * 60 + minute! * 60))
        print("finishedDate \(finishedDate.description)")
        time = Int(finishedDate.timeIntervalSince(currentDate) / (60 * 60))
        print("time \(time)")

        for user in result.myPosting![myRunningIdx].runnerList! {
            userList.append(user.userID!)
            attendList.append("-")
        }
    }

    func didSuccessPatchAttendance(_: BaseResponse) {
        view.makeToast("출석이 제출되었습니다.")
    }

    func failedToRequest(message: String) {
        print(message)
    }
}
