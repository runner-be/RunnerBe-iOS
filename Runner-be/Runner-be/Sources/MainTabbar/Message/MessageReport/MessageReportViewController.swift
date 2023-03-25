//
//  MessageReportViewController.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

class MessageReportViewController: BaseViewController {
    var messages: [MessageContent] = []
    var postId = 0
    var reportMessageList: [Int] = []
    var reportMessageIndexString = ""

    lazy var messageDataManager = MessageDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInputs()
        viewModelInput()
        viewModelOutput()

        viewModel.routeInputs.needUpdate.onNext(true)
    }

    init(viewModel: MessageReportViewModel, roomId _: Int) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageReportViewModel

    private func viewInputs() { // 얘는 이벤트가 들어오되 뷰모델을 거치지 않아도 되는애들
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .map { self.reportMessageList.map { String($0) }.joined(separator: ",") }
            .bind(to: viewModel.inputs.report)
            .disposed(by: disposeBag)

        postSection.rx.tapGesture()
            .when(.recognized)
            .map { _ in self.postId }
            .bind(to: viewModel.inputs.detailPost)
            .disposed(by: disposeBag)
    }

    private func viewModelInput() { // 얘는 이벤트가 뷰모델로 전달이 되어야할 때 쓰는 애들
    }

    private func viewModelOutput() { // 뷰모델에서 뷰로 데이터가 전달되어 뷰의 변화가 반영되는 부분
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.roomInfo
            .subscribe(onNext: { roomInfo in
                self.postSection.badgeLabel.setTitle(roomInfo.runningTag, for: .normal)
                self.postSection.postTitle.text = roomInfo.title
                self.postId = roomInfo.postId!
            })
            .disposed(by: disposeBag)

        viewModel.outputs.messageContents
            .do(onNext: { contents in
                self.messages = contents
            })
            .bind(to: messageReportTableView.rx.items) { _, _, item -> UITableViewCell in

                let dateUtil = DateUtil.shared

                let date = dateUtil.apiDateStringToDate(item.createdAt!)

                if item.messageFrom == "Others" {
                    let cell = self.messageReportTableView.dequeueReusableCell(withIdentifier: MessageChatLeftCell.id) as! MessageChatLeftCell

                    cell.delegate = self // MessageChatReportDelegate

                    cell.selectionStyle = .none
                    cell.separatorInset = .zero // 구분선 제거

                    cell.messageContent.text = item.content
                    cell.nickName.text = item.nickName
                    cell.messageDate.text = dateUtil.formattedString(for: date!, format: DateFormat.messageTime)
                    cell.checkBox.isHidden = false

                    if item.whetherPostUser == "Y" {
                        cell.bubbleBackground.backgroundColor = .primary
                        cell.messageContent.textColor = .black
                    } else {
                        cell.bubbleBackground.backgroundColor = .darkG55
                        cell.messageContent.textColor = .darkG1
                    }

                    return cell
                } else {
                    let cell = self.messageReportTableView.dequeueReusableCell(withIdentifier: MessageChatRightCell.id) as! MessageChatRightCell

                    cell.selectionStyle = .none
                    cell.separatorInset = .zero

                    cell.messageContent.text = item.content
                    cell.messageDate.text = dateUtil.formattedString(for: date!, format: DateFormat.messageTime)

                    if item.whetherPostUser == "Y" {
                        cell.bubbleBackground.backgroundColor = .primary
                        cell.messageContent.textColor = .black
                    } else {
                        cell.bubbleBackground.backgroundColor = .darkG55
                        cell.messageContent.textColor = .darkG1
                    }
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(nil, for: .normal) // 버튼 지우기
        navBar.rightBtnItem.setTitle(L10n.MessageList.NavBar.rightItem, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG35, for: .normal)
        navBar.rightBtnItem.isEnabled = false
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.titleLabel.text = L10n.MessageList.Chat.NavBar.title
    }

    var postSection = MessagePostView().then { view in
        view.badgeLabel.titleLabel?.text = "출근 전"
        view.postTitle.text = "불금에 달리기하실분!"
    }

    private var messageReportTableView = UITableView().then { view in
        view.register(MessageChatLeftCell.self, forCellReuseIdentifier: MessageChatLeftCell.id) // 케이스에 따른 셀을 모두 등록
        view.register(MessageChatRightCell.self, forCellReuseIdentifier: MessageChatRightCell.id)
        view.backgroundColor = .darkG7
        view.separatorColor = .clear
        view.showsVerticalScrollIndicator = false
    }
}

// MARK: - Layout

extension MessageReportViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            postSection,
            messageReportTableView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        postSection.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }

        messageReportTableView.snp.makeConstraints { make in
            make.top.equalTo(postSection.snp.bottom).offset(22)
            make.leading.equalTo(self.view.snp.leading).offset(16)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MessageReportViewController: MessageChatReportDelegate {
    func checkButtonTap(cell: MessageChatLeftCell) {
        if cell.checkBox.isSelected { // 선택한 것만 가져오기
            let index = messages[messageReportTableView.indexPath(for: cell)!.row].messageId ?? 0
//            print(index)
            reportMessageList.append(index)
        } else { // 제외하기
            reportMessageList = reportMessageList.filter { $0 != messages[messageReportTableView.indexPath(for: cell)!.row].messageId }
        }

        if !reportMessageList.isEmpty {
            navBar.rightBtnItem.isEnabled = true
            navBar.rightBtnItem.setTitleColor(.primary, for: .normal)
        } else {
            navBar.rightBtnItem.isEnabled = false
            navBar.rightBtnItem.setTitleColor(.darkG4, for: .normal)
        }
    }
}
