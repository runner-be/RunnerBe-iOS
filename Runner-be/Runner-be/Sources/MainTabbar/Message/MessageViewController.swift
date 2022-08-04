//
//  MessageViewController.swift
//  Runner-be
//
//  Created by 이유리 on 2022/04/26.
//

import Kingfisher
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MessageViewController: BaseViewController {
    lazy var myDataManager = MessageDataManager()
    var messageList = [GetMessageListResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.id)

        myDataManager.getMessageList(viewController: self)

        viewInputs()
        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MessageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageViewModel

    private func viewInputs() { // 얘는 이벤트가 들어오되 뷰모델을 거치지 않아도 되는애들
    }

    private func viewModelInput() { // 얘는 이벤트가 뷰모델로 전달이 되어야할 때 쓰는 애들
    }

    private func viewModelOutput() {} // 뷰모델에서 뷰로 데이터가 전달되어 뷰의 변화가 반영되는 부분

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MessageList.NavBar.title
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.rightBtnItem.setTitle(L10n.MessageList.NavBar.rightItem, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG5, for: .highlighted)
        navBar.rightBtnItem.titleLabel?.font = .iosBody17R
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 12
    }

    private var tableView = UITableView()
}

// MARK: - Layout

extension MessageViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            tableView,
        ])

        tableView.backgroundColor = .darkG7
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messageList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.id) as? MessageTableViewCell else { return .init() }
        cell.selectionStyle = .none // 셀 클릭 시 반짝임 효과 제거
        if !messageList.isEmpty {
            if messageList[indexPath.row].profileImageUrl != nil {
                cell.messageProfile.kf.setImage(with: URL(string: messageList[indexPath.row].profileImageUrl!), placeholder: Asset.profileEmptyIcon.uiImage)
            } else {
                cell.messageProfile.image = Asset.profileEmptyIcon.uiImage
            }
            cell.postTitle.text = messageList[indexPath.row].title
            cell.nameLabel.text = messageList[indexPath.row].repUserName

            if messageList[indexPath.row].recentMessage == "N" { // 읽은 메시지가 아니면
                cell.backgroundColor = .primaryBestDark
            } else {
                cell.backgroundColor = .clear
            }
        }
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 76
    }


    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {}
}

extension MessageViewController {
    func didSucessGetMessageList(_ result: [GetMessageListResult]) {
        messageList.append(contentsOf: result)
        tableView.reloadData()
    }

    func failedToRequest(message: String) {
        print(message)
    }
}
