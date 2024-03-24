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
    var userIdList: [Int] = [] // 유저 id 리스트
    var whetherAttendList: [String] = [] // 위 각각 유저 별로 참여 여부를 저장하는 리스트

    let currentDate = DateUtil.shared.now.addingTimeInterval(TimeInterval(9 * 60 * 60)) // 타임존때문에 9시간 더 더해줘야함
    var gatherDate = Date()
    var runningTime = TimeInterval()
    var time = 0
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()

        manageAttendanceTableView.delegate = self
        manageAttendanceTableView.dataSource = self

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)

        viewModel.routeInputs.needUpdate.onNext(true)
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

        saveButton.rx.tap
            .filter { !self.whetherAttendList.contains("-") }
            .map { (userIdList: self.userIdList.map { String($0) }.joined(separator: ","), whetherAttendList: self.whetherAttendList.joined(separator: ",")) }
            .bind(to: viewModel.inputs.patchAttendance)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.info
            .subscribe(onNext: { info in
                if info.attendTimeOver! == "Y" { // 출석 관리 마감 여부
                    self.navBar.titleLabel.text = L10n.MyPage.MyPost.Manage.Finished.title
                    self.saveButton.isHidden = true

                    self.timeView.isHidden = true
                    self.timeFirstLabel.isHidden = true
                    self.timeSecondLabel.isHidden = true
                    self.timeThirdLabel.isHidden = true

                    self.manageAttendanceTableView.snp.makeConstraints { make in
                        make.top.equalTo(self.view.snp.top)
                        make.leading.equalTo(self.view.snp.leading)
                        make.trailing.equalTo(self.view.snp.trailing)
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                    }
                } else { // 출석이 완료되지 않을 경우
                    self.navBar.titleLabel.text = L10n.MyPage.MyPost.Manage.After.title
                    self.saveButton.isHidden = false

                    self.timeView.isHidden = false
                    self.timeFirstLabel.isHidden = false
                    self.timeSecondLabel.isHidden = false
                    self.timeThirdLabel.isHidden = false

                    self.manageAttendanceTableView.snp.makeConstraints { make in
                        make.top.equalTo(self.view.snp.top)
                        make.leading.equalTo(self.view.snp.leading)
                        make.trailing.equalTo(self.view.snp.trailing)
                        make.bottom.equalTo(self.saveButton.snp.top).offset(8)
                    }
                }

                let formatter = DateUtil.shared.dateFormatter
                formatter.dateFormat = DateFormat.apiDate.formatString

                let dateString = info.gatheringTime!
                print("dateString : \(dateString)")
                self.gatherDate = DateUtil.shared.apiDateStringToDate(dateString)!

                let hms = info.runningTime?.components(separatedBy: ":") // hour miniute seconds
                let hour = Int(hms![0])
                let minute = Int(hms![1])

                // 모임 날짜
                self.gatherDate = self.gatherDate.addingTimeInterval(TimeInterval(9 * 60 * 60))

                // 출석 마감 날짜
                let finishedDate = self.gatherDate.addingTimeInterval(TimeInterval((hour! + 3) * 60 * 60 + minute! * 60))
                print("finishedDate \(finishedDate.description)")

                // 현재 - 출석 마감 날짜 남은 분
                print(self.currentDate.description)
                let offsetComps = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self.currentDate, to: finishedDate)
                self.time = offsetComps.hour! * 60 * 60 + offsetComps.minute! * 60 + offsetComps.second! // 출석관리 마감까지 남은 초
                //        time = 5 // 마이페이지 모달 이동 테스트용
                print("hour \(offsetComps.hour!) minute \(offsetComps.minute!) second \(offsetComps.second!)")
            })
            .disposed(by: disposeBag)

        viewModel.outputs.runnerList
            .subscribe(onNext: { runnerList in
                self.userIdList = runnerList.map { $0.userID! }
                self.whetherAttendList = Array(repeating: "-", count: runnerList.count)

                self.manageAttendanceTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    @objc func timerCallback() {
        time -= 1
        timeSecondLabel.text = "\(Int(time / (60 * 60))) 시간 \(Int((time / 60) % 60)) 분"

        if time == 0 {
            timer?.invalidate()
            viewModel.inputs.showExpiredModal.onNext(())
        }
    }

    private var manageAttendanceTableView = UITableView(frame: .zero, style: .grouped).then { view in
        // style.grouped는 header와 cell을 같이 스크롤되게 하기 위함
        view.register(ManageAttendanceCell.self, forCellReuseIdentifier: ManageAttendanceCell.id) // 케이스에 따른 셀을 모두 등록
        view.separatorStyle = .none
        view.contentInsetAdjustmentBehavior = .never // 위에 빈 space 있는거 방지
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.backgroundColor = .darkG7
        navBar.titleLabel.text = L10n.MyPage.MyPost.Manage.After.title
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
        view.isHidden = true
    }
}

// layout
extension ManageAttendanceViewController {
    private func setupViews() {
        view.backgroundColor = .black

        view.addSubviews([
            manageAttendanceTableView,
            saveButton,
        ])
    }

    private func initialLayout() {
        manageAttendanceTableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(saveButton.snp.top).offset(8)
        }

        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -42 : -8)
        }
    }
}

extension ManageAttendanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.runnerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageAttendanceCell.id) as? ManageAttendanceCell else { return .init() }
        cell.selectionStyle = .none

        let runnerList = viewModel.runnerList

        // user 세팅하기 -> profileImageURL이 null인 경우가 있으니, null일 경우엔 빈값으로 두어서 대응
        let user = User(userID: runnerList[indexPath.row].userID!, nickName: runnerList[indexPath.row].nickName!, gender: runnerList[indexPath.row].gender!, age: runnerList[indexPath.row].age!, diligence: runnerList[indexPath.row].diligence!, pushOn: "Y", job: runnerList[indexPath.row].job!, profileImageURL: runnerList[indexPath.row].profileImageURL ?? "", pace: runnerList[indexPath.row].pace)
        var isUser = false

        if runnerList[indexPath.row].whetherPostUser == "Y" {
            isUser = true
        } else {
            isUser = false
        }

        cell.configure(userInfo: UserConfig(from: user, owner: isUser))

        // 출석관리하기 버튼 / 결과값 여부
        let attendTimeOver = viewModel.attendTimeOver

        if attendTimeOver == "Y" { // 출석관리 마감시간 여부
            timeView.isHidden = true
            cell.resultView.isHidden = false
            cell.refusalBtn.isHidden = true
            cell.acceptBtn.isHidden = true

            if runnerList[indexPath.row].whetherCheck == "Y" { // 리더가 출석체크했음
                if runnerList[indexPath.row].attendance == 0 {
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
                        cell.refusalBtn.titleLabel?.font = .iosBody15B

                        cell.acceptBtn.isSelected = false
                        cell.acceptBtn.backgroundColor = .clear
                        cell.acceptBtn.setTitleColor(.darkG3, for: .normal)
                        cell.acceptBtn.titleLabel?.font = .iosBody15R

                        self.whetherAttendList[indexPath.row] = "N"

                    } else { // 활성 -> 비활성
                        cell.refusalBtn.isSelected = false
                        cell.refusalBtn.backgroundColor = .clear
                        cell.refusalBtn.setTitleColor(.darkG3, for: .normal)
                        cell.refusalBtn.titleLabel?.font = .iosBody15R

                        self.whetherAttendList[indexPath.row] = "-"
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
                        cell.acceptBtn.titleLabel?.font = .iosBody15B

                        cell.refusalBtn.isSelected = false
                        cell.refusalBtn.backgroundColor = .clear
                        cell.refusalBtn.setTitleColor(.darkG3, for: .normal)
                        cell.refusalBtn.titleLabel?.font = .iosBody15R

                        self.whetherAttendList[indexPath.row] = "Y"

                    } else { // 활성 -> 비활성
                        cell.acceptBtn.isSelected = false
                        cell.acceptBtn.backgroundColor = .clear
                        cell.acceptBtn.setTitleColor(.darkG3, for: .normal)
                        cell.acceptBtn.titleLabel?.font = .iosBody15R

                        self.whetherAttendList[indexPath.row] = "-"
                    }

                })
                .disposed(by: disposeBag)
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return CGFloat(176)
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        if viewModel.attendTimeOver == "Y" { // 출석확인
            return AppContext.shared.safeAreaInsets.top + AppContext.shared.navHeight
        } else { // 출석관리
            return AppContext.shared.safeAreaInsets.top + AppContext.shared.navHeight + 48
        }
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? { // 섹션 뷰
        if viewModel.attendTimeOver == "Y" {
            navBar.snp.makeConstraints { make in
                make.width.equalTo(view.frame.width)
            }
            return navBar
        } else {
            let contentView = UIView()

            contentView.addSubviews([
                navBar,
                timeView,
            ])

            timeView.addSubviews([
                timeFirstLabel,
                timeSecondLabel,
                timeThirdLabel,
            ])

            contentView.snp.makeConstraints { make in
                make.width.equalTo(view.frame.width)
                make.height.equalTo(140)
            }

            navBar.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.top)
                make.leading.equalTo(contentView.snp.leading)
                make.trailing.equalTo(contentView.snp.trailing)
            }

            timeView.snp.makeConstraints { make in
                make.top.equalTo(navBar.snp.bottom)
                make.leading.equalTo(contentView.snp.leading)
                make.trailing.equalTo(contentView.snp.trailing)
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

            return contentView
        }
    }
}

extension ManageAttendanceViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 { // 아래에만 bounce 되게 처리
            scrollView.contentOffset = CGPoint.zero
        }
    }
}
