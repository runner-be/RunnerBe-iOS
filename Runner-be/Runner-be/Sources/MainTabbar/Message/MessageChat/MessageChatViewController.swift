//
//  MessageViewController.swift
//  Runner-be
//
//  Created by 이유리 on 2022/04/26.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MessageChatViewController: BaseViewController {
    var messages: [MessageList] = []
    var messageId = 0
    var postId = 0

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

        chatTextView.delegate = self

        messageDataManager.getMessageChat(viewController: self, roomId: messageId)
    }

    init(viewModel: MessageChatViewModel, messageId: Int) {
        self.viewModel = viewModel
        self.messageId = messageId
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageChatViewModel

    private func viewInputs() { // 얘는 이벤트가 들어오되 뷰모델을 거치지 않아도 되는애들
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .map { _ in self.messageId }
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
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.text = L10n.MessageList.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = false
        navBar.rightBtnItem.setImage(Asset.iconsReport24.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 12
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

    var chatBackGround = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    var chatTextView = UITextView().then { view in
        view.backgroundColor = .darkG5
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 32
        view.clipsToBounds = true

        view.contentInset = .init(top: 8, left: 14, bottom: 18, right: 44)
//        view.textContainerInset = .init(top: 8, left: 14, bottom: 18, right: 44)
        view.font = .iosBody15R
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
    }

    var sendButton = UIButton().then { view in
        view.setImage(Asset.iconsSend24.uiImage, for: .normal)
    }
}

// MARK: - Layout

extension MessageChatViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            postSection,
            tableView,
            chatBackGround,
        ])

        chatBackGround.addSubviews([
            chatTextView,
        ])

        chatTextView.addSubviews([
            sendButton,
        ])

        chatBackGround.bringSubviewToFront(chatTextView)
        chatTextView.bringSubviewToFront(sendButton)
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
            make.bottom.equalTo(self.chatBackGround.snp.top)
        }

        chatBackGround.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.greaterThanOrEqualTo(84)
            make.height.lessThanOrEqualTo(118)
        }

        chatTextView.snp.makeConstraints { make in
            make.leading.equalTo(chatBackGround.snp.leading).offset(16)
            make.trailing.equalTo(chatBackGround.snp.trailing).offset(-16)
            make.bottom.equalTo(chatBackGround.snp.bottom).offset(-45)
            make.top.equalTo(chatBackGround.snp.top).offset(12)
            make.height.greaterThanOrEqualTo(30)
            make.height.lessThanOrEqualTo(60)
        }

        sendButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.bottom.equalTo(chatTextView.textInputView.snp.bottom).offset(-6)
            make.trailing.equalTo(chatTextView.textInputView.snp.trailing).offset(-12)
        }

        let tapSendMessage = UITapGestureRecognizer(target: self, action: #selector(tapSendMessage(_:)))
        sendButton.addGestureRecognizer(tapSendMessage)
    }

    @objc
    func tapSendMessage(_: UITapGestureRecognizer) {
        messageDataManager.postMessage(viewController: self, roomId: messageId, content: chatTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

extension MessageChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateUtil.shared.dateFormatter
        formatter.dateFormat = DateFormat.apiDate.formatString
        let dateUtil = DateUtil.shared

        if !messages.isEmpty {
            let date = formatter.date(from: messages[indexPath.row].createdAt!)

            if messages[indexPath.row].messageFrom == "Others" {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageChatLeftCell.id) as! MessageChatLeftCell

                cell.selectionStyle = .none
                cell.separatorInset = .zero // 구분선 제거

                cell.messageContent.text = messages[indexPath.row].content!
                cell.nickName.text = messages[indexPath.row].nickName
                cell.messageDate.text = dateUtil.formattedString(for: date!, format: DateFormat.messageTime)

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

extension MessageChatViewController: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        if !chatTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
}

extension MessageChatViewController {
    func didSucessGetMessageChat(_ result: GetMessageChatResult) {
        postSection.badgeLabel.setTitle(result.roomInfo?[0].runningTag, for: .normal)
        postSection.postTitle.text = result.roomInfo?[0].title
        postId = result.roomInfo?[0].postId! ?? 0

        messages.removeAll()
        messages.append(contentsOf: result.messageList!)
        tableView.reloadData()
    }

    func didSuccessPostMessage(_: BaseResponse) {
        messageDataManager.getMessageChat(viewController: self, roomId: messageId)
    }

    func failedToRequest(message: String) {
        print(message)
    }
}
