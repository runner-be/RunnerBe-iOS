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

//        messageInputView.delegate = self
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

        messageInputView.sendButtonTapped
            .bind(to: viewModel.inputs.sendMessage)
            .disposed(by: disposeBag)

        messageInputView.plusImageButtonTapped
            .bind(to: viewModel.inputs.tapPostImage)
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
            .bind(to: messageInputView.messageSendStatusSubject)
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

        viewModel.outputs.showPicker
            .bind { type in
                print("MessageRoomViewController - ShowPicker, \(type)")
            }.disposed(by: disposeBag)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.backgroundColor = .darkG7
        navBar.titleLabel.text = L10n.MessageList.NavBar.title
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = false
        navBar.rightBtnItem.setImage(Asset.iconsReport24.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
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

    private let messageInputView = MessageInputView().then {
        // TODO: 색상코드이름
        $0.backgroundColor = UIColor(white: 29.0 / 255.0, alpha: 1.0)
        $0.cornerRadius = 19
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        $0.placeHolder = L10n.MessageList.Chat.placeHolder

        $0.font = .pretendardRegular14
        $0.textColor = .darkG35
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
            messageInputView,
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
            make.bottom.equalTo(self.messageInputView.snp.top)
        }

        messageInputView.snp.makeConstraints {
            $0.top.equalTo(messageContentsTableView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.3) {
                self.messageInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardRectangle.height)
                }
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc
    func keyboardWillHide(_: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.messageInputView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(0)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// extension MessageRoomViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) { // textview edit 시작
//        if textView.text == L10n.MessageList.Chat.placeHolder {
//            textView.text = nil // placeholder 제거
//            textView.textColor = .darkG1
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            // 비어있을 경우 placeholder 노출
//            textView.text = L10n.MessageList.Chat.placeHolder
//            textView.textColor = .darkG35
//        }
//    }

//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            sendButton.isEnabled = false
//        } else {
//            sendButton.isEnabled = true
//        }
//    }
// }
