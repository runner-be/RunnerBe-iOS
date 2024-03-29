//
//  MessageRoomViewController.swift
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

class MessageRoomViewController: BaseViewController {
    let formatter = DateUtil.shared.dateFormatter
    let dateUtil = DateUtil.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInputs()
        viewModelInput()
        viewModelOutput()

        formatter.dateFormat = DateFormat.apiDate.formatString

        chatTextView.delegate = self
        dismissKeyboardWhenTappedAround()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    init(viewModel: MessageRoomViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageRoomViewModel

    private func viewInputs() { // 얘는 이벤트가 들어오되 뷰모델을 거치지 않아도 되는애들
        viewModel.routeInputs.needUpdate.onNext(true)

        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.report)
            .disposed(by: disposeBag)

        postSection.rx.tapGesture()
            .when(.recognized)
            .map { _ in self.viewModel.roomInfo?.postId ?? -1 }
            .bind(to: viewModel.inputs.detailPost)
            .disposed(by: disposeBag)

        sendButton.rx.tap
            .map { self.chatTextView.text ?? "" }
            .filter { $0 != "" } // 입력창이 비어있으면 전송 요청이 안되도록
            .bind(to: viewModel.inputs.sendMessage)
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
            })
            .disposed(by: disposeBag)

        viewModel.outputs.successSendMessage
            .subscribe(onNext: { isSuccessSendMessage in
                if isSuccessSendMessage {
                    self.chatTextView.text.removeAll()
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.messageContents
            .filter { [weak self] contents in
                if contents.isEmpty {
                    self!.messageContentsTableView.isHidden = true
                    return false
                } else {
                    self!.messageContentsTableView.isHidden = false
                    return true
                }
            }
            .bind(to: messageContentsTableView.rx.items) { _, _, item -> UITableViewCell in

                let date = self.dateUtil.apiDateStringToDate(item.createdAt!)

                if item.messageFrom == "Others" {
                    let cell = self.messageContentsTableView.dequeueReusableCell(withIdentifier: MessageChatLeftCell.id) as! MessageChatLeftCell

                    cell.selectionStyle = .none
                    cell.separatorInset = .zero // 구분선 제거

                    cell.messageContent.text = item.content
                    cell.nickName.text = item.nickName
                    cell.messageDate.text = self.dateUtil.formattedString(for: date!, format: DateFormat.messageTime)

                    if item.whetherPostUser == "Y" {
                        cell.bubbleBackground.backgroundColor = .primary
                        cell.messageContent.textColor = .black
                    } else {
                        cell.bubbleBackground.backgroundColor = .darkG55
                        cell.messageContent.textColor = .darkG1
                    }
                    return cell

                } else {
                    let cell = self.messageContentsTableView.dequeueReusableCell(withIdentifier: MessageChatRightCell.id) as! MessageChatRightCell

                    cell.selectionStyle = .none
                    cell.separatorInset = .zero

                    cell.messageContent.text = item.content
                    cell.messageDate.text = self.dateUtil.formattedString(for: date!, format: DateFormat.messageTime)

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

        viewModel.outputs.messageContents
            .filter { !$0.isEmpty }
            .subscribe(onNext: { messages in
                self.messageContentsTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true) // 맨 마지막 내용으로 이동하도록
            })
            .disposed(by: disposeBag)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.backgroundColor = .darkG7
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
        view.badgeLabel.titleLabel?.text = "태그"
        view.postTitle.text = "게시글 제목"
    }

    private var messageContentsTableView = UITableView().then { view in
        view.register(MessageChatLeftCell.self, forCellReuseIdentifier: MessageChatLeftCell.id) // 케이스에 따른 셀을 모두 등록
        view.register(MessageChatRightCell.self, forCellReuseIdentifier: MessageChatRightCell.id)
        view.backgroundColor = .darkG7
        view.separatorColor = .clear
    }

    var chatBackGround = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    var chatTextView = UITextView().then { view in
        // background
        view.backgroundColor = .darkG5
        view.layer.borderWidth = 0
        view.clipsToBounds = true
        view.layer.cornerRadius = 19

        // textview padding
        view.textContainerInset = UIEdgeInsets(top: 8, left: 14, bottom: 18, right: 44)

        view.font = .iosBody15R

        // place holder 설정
        view.text = L10n.MessageList.Chat.placeHolder
        view.textColor = .darkG35
        view.showsVerticalScrollIndicator = false
    }

    var sendButton = UIButton().then { view in
        view.isEnabled = false
        view.setImage(Asset.iconsSend24.uiImage, for: .normal)
    }
}

// MARK: - Layout

extension MessageRoomViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            postSection,
            messageContentsTableView,
            chatBackGround,
        ])

        chatBackGround.addSubviews([
            chatTextView,
            sendButton,
        ])

        view.bringSubviewToFront(navBar)
        view.bringSubviewToFront(postSection)
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

        messageContentsTableView.snp.makeConstraints { make in
            make.top.equalTo(postSection.snp.bottom).offset(10) // postSection만큼 떨어뜨리기
            make.leading.equalTo(self.view.snp.leading).offset(16)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
            make.bottom.equalTo(self.chatBackGround.snp.top)
        }

        chatBackGround.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(UIScreen.main.isWiderThan375pt ? 96 : 62)
        }

        chatTextView.snp.makeConstraints { make in
            make.leading.equalTo(chatBackGround.snp.leading).offset(16)
            make.trailing.equalTo(chatBackGround.snp.trailing).offset(-52)
            make.top.equalTo(chatBackGround.snp.top).offset(12)
            make.height.equalTo(38)
        }

        sendButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.centerY.equalTo(chatTextView.snp.centerY)
            make.trailing.equalTo(chatBackGround.snp.trailing).offset(-16)
        }
    }

    @objc
    func keyboardWillShow(_ notification: Notification) { // keyboardFrameEndUserInfoKey : 키보드가 차지하는 frame의 CGRect값 반환
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            chatBackGround.frame.origin.y -= (keyboardHeight - AppContext.shared.safeAreaInsets.bottom)
            messageContentsTableView.contentInset.bottom = keyboardHeight - AppContext.shared.safeAreaInsets.bottom
            if messageContentsTableView.numberOfRows(inSection: 0) != 0 {
                messageContentsTableView.scrollToRow(at: IndexPath(row: messageContentsTableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true) // 맨 마지막 내용으로 이동하도록
            }
        }
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            chatBackGround.frame.origin.y += (keyboardHeight - AppContext.shared.safeAreaInsets.bottom)
            messageContentsTableView.contentInset.bottom = 0
            if messageContentsTableView.numberOfRows(inSection: 0) != 0 {
                messageContentsTableView.scrollToRow(at: IndexPath(row: messageContentsTableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true) // 맨 마지막 내용으로 이동하도록
            }
        }
    }
}

extension MessageRoomViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) { // textview edit 시작
        if textView.text == L10n.MessageList.Chat.placeHolder {
            textView.text = nil // placeholder 제거
            textView.textColor = .darkG1
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // 비어있을 경우 placeholder 노출
            textView.text = L10n.MessageList.Chat.placeHolder
            textView.textColor = .darkG35
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
