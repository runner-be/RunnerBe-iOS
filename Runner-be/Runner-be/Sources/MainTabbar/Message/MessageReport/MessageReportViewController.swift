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
    var messageId = 0
    var postId = 0
    var reportMessageList: [Int] = []
    var reportMessageIndexString = ""
    var toastMessage = ""

    lazy var messageDataManager = MessageDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInputs()
        viewModelInput()
        viewModelOutput()

        tableView.delegate = self
        tableView.dataSource = self

//        chatTextView.delegate = self

        messageDataManager.getMessageChat(viewController: self, roomId: messageId)
    }

    init(viewModel: MessageReportViewModel, messageId: Int) {
        self.viewModel = viewModel
        self.messageId = messageId
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
            .subscribe(onNext: { [weak self] message in
                guard let message = message else { return }
                self!.reportMessageIndexString = self!.reportMessageList.map(String.init).joined(separator: ",") // 인덱스 separator ,로 붙여서 전달
                print(self!.reportMessageIndexString)
                self!.toastMessage = message // 메시지 세팅
//                self!.view.makeToast(message)
                self!.messageDataManager.reportMessage(viewController: self!, messageIdList: self!.reportMessageIndexString)
            })
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

    private var tableView = UITableView().then { view in
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
            tableView,
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

        tableView.snp.makeConstraints { make in
            make.top.equalTo(postSection.snp.bottom).offset(22)
            make.leading.equalTo(self.view.snp.leading).offset(16)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

//        chatBackGround.snp.makeConstraints { make in
//            make.leading.equalTo(self.view.snp.leading)
//            make.trailing.equalTo(self.view.snp.trailing)
//            make.bottom.equalTo(self.view.snp.bottom)
//            make.height.greaterThanOrEqualTo(84)
//            make.height.lessThanOrEqualTo(118)
//        }
//
//        chatTextView.snp.makeConstraints { make in
//            make.leading.equalTo(chatBackGround.snp.leading).offset(16)
//            make.trailing.equalTo(chatBackGround.snp.trailing).offset(-16)
//            make.bottom.equalTo(chatBackGround.snp.bottom).offset(-45)
//            make.top.equalTo(chatBackGround.snp.top).offset(12)
//            make.height.greaterThanOrEqualTo(30)
//            make.height.lessThanOrEqualTo(60)
//        }
//
//        sendButton.snp.makeConstraints { make in
//            make.width.equalTo(24)
//            make.height.equalTo(24)
//            make.bottom.equalTo(chatTextView.textInputView.snp.bottom).offset(-6)
//            make.trailing.equalTo(chatTextView.textInputView.snp.trailing).offset(-12)
//        }
    }
}

extension MessageReportViewController: UITableViewDelegate, UITableViewDataSource, MessageChatReportDelegate {
    func checkButtonTap(cell: MessageChatLeftCell) {
        if cell.checkBox.isSelected { // 선택한 것만 가져오기
            let index = messages[tableView.indexPath(for: cell)!.row].messageId ?? 0
//            print(index)
            reportMessageList.append(index)
        } else { // 제외하기
            reportMessageList = reportMessageList.filter { $0 != messages[tableView.indexPath(for: cell)!.row].messageId }
        }

        if !reportMessageList.isEmpty {
            navBar.rightBtnItem.isEnabled = true
            navBar.rightBtnItem.setTitleColor(.primary, for: .normal)
        } else {
            navBar.rightBtnItem.isEnabled = false
            navBar.rightBtnItem.setTitleColor(.darkG4, for: .normal)
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let formatter = DateUtil.shared.dateFormatter
//        formatter.dateFormat = DateFormat.apiDate.formatString
        let dateUtil = DateUtil.shared

        if !messages.isEmpty {
//            let date = formatter.date(from: messages[indexPath.row].createdAt!)
            let date = dateUtil.apiDateStringToDate(messages[indexPath.row].createdAt!)

            if messages[indexPath.row].messageFrom == "Others" {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageChatLeftCell.id) as! MessageChatLeftCell
                cell.delegate = self // 위 MessageChatReportDelegate를 동작시키려면 반드시 이 delegate가 자기자신임을 명시해주어야함 !!

                cell.selectionStyle = .none
                cell.separatorInset = .zero // 구분선 제거

                cell.messageContent.text = messages[indexPath.row].content!
                cell.nickName.text = messages[indexPath.row].nickName
                cell.messageDate.text = dateUtil.formattedString(for: date!, format: DateFormat.messageTime)
                cell.checkBox.isHidden = false

                if messages[indexPath.row].whetherPostUser == "Y" {
                    cell.bubbleBackground.backgroundColor = .primary
                    cell.messageContent.textColor = .black
                } else {
                    cell.bubbleBackground.backgroundColor = .darkG55
                    cell.messageContent.textColor = .darkG1
                }

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageChatRightCell.id) as! MessageChatRightCell

                cell.selectionStyle = .none
                cell.separatorInset = .zero

                cell.messageContent.text = messages[indexPath.row].content!
                cell.messageDate.text = dateUtil.formattedString(for: date!, format: DateFormat.messageTime)

                if messages[indexPath.row].whetherPostUser == "Y" {
                    cell.bubbleBackground.backgroundColor = .primary
                    cell.messageContent.textColor = .black
                } else {
                    cell.bubbleBackground.backgroundColor = .darkG55
                    cell.messageContent.textColor = .darkG1
                }
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
//    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
//        return 76
//    }
}

extension MessageReportViewController {
    func didSucessGetMessageChat(_ result: GetMessageChatResult) {
        postSection.badgeLabel.setTitle(result.roomInfo?[0].runningTag, for: .normal)
        postSection.postTitle.text = result.roomInfo?[0].title
        postId = result.roomInfo?[0].postId! ?? 0

        messages.removeAll()
        messages.append(contentsOf: result.messageList!)
        tableView.reloadData()
    }

    func didSuccessReportMessage(_: BaseResponse) {
        view.makeToast(toastMessage)
    }

    func failedToRequest(message: String) {
        print(message)
    }
}
