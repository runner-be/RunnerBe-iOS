//
//  MessageViewController.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import FirebaseFirestore
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MessageChatViewController: BaseViewController {
    var messages: [MessageList] = []
    var messageId = 0
    lazy var messageDataManager = MessageDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInputs()
        viewModelInput()
        viewModelOutput()

//        messageDataManager.get
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

//        navBar.rightBtnItem.rx.tap
//            .bind(to: viewModel.inputs.report)
//            .disposed(by: disposeBag)
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
        view.badgeLabel.text = "출근 전"
        view.postTitle.text = "불금에 달리기하실분!"
    }

    private var tableView = UITableView()
}

// MARK: - Layout

extension MessageChatViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            postSection,
            tableView,
        ])

        tableView.backgroundColor = .darkG7
        // 선택시 하이라이트 효과 없애야함
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
        }
    }
}

extension MessageChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!

//        if !messages.isEmpty {
//            if messages[indexPath.row].messageFrom == "Others" {
//                cell = tableView.dequeueReusableCell(withIdentifier: MessageChatLeftCell.id) as! MessageChatLeftCell
//                if messages[indexPath.row].whetherPostUser == "Y" {
//                    cell.bubbleBackground.backgroundColor = .primary
//                } else {
//                    cell?.bubbleBackground.backgroundColor = .darkG55
//                }
//            } else {
//                cell = tableView.dequeueReusableCell(withIdentifier: MessageChatRightCell.id) as? MessageChatRightCell
//                if messages[indexPath.row].whetherPostUser == "Y" {
//                    cell?.bubbleBackground.backgroundColor = .primary
//                } else {
//                    cell?.bubbleBackground.backgroundColor = .darkG55
//                }
//            }
//        } else {
//            cell = UITableViewCell()
//        }

        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
//    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
//        return 76
//    }
}

extension MessageChatViewController {
    func didSucessGetMessageChat(_ result: GetMessageChatResult) {
        postSection.badgeLabel.text = result.roomInfo?[0].runningTag
        postSection.postTitle.text = result.roomInfo?[0].title

        if !result.messageList!.isEmpty {
            messages = result.messageList!
            tableView.reloadData()
        }
    }

    func failedToRequest(message: String) {
        print(message)
    }
}
