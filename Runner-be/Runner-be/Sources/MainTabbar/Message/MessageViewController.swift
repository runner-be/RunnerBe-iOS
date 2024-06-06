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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

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

    private func viewInputs() {}

    private func viewModelInput() {
        tableView.rx.modelSelected(MessageRoom.self)
            .compactMap { $0.roomId }
            .bind(to: viewModel.inputs.messageRoomId)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.messageRoomList
            .filter { [weak self] array in
                if array.isEmpty {
                    self!.tableView.isHidden = true
                    return false
                } else {
                    self!.tableView.isHidden = false
                    return true
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: MessageTableViewCell.id, cellType: MessageTableViewCell.self)) { _, item, cell in

                cell.selectionStyle = .none

                if let profileUrl = item.profileImageUrl {
                    cell.messageProfile.kf.setImage(with: URL(string: profileUrl), placeholder: Asset.profileEmptyIcon.uiImage)
                } else {
                    cell.messageProfile.image = Asset.profileEmptyIcon.uiImage
                }
                cell.postTitle.text = item.title
                cell.nameLabel.text = item.repUserName

                if item.recentMessage == "Y" { // 안읽은 메시지 여부 : 있음
                    cell.backgroundColor = .primaryBestDark
                } else {
                    cell.backgroundColor = .clear
                }
            }
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MessageList.NavBar.title
        navBar.rightBtnItem.setTitle(L10n.MessageList.NavBar.rightItem, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG3, for: .normal)
        navBar.rightBtnItem.setTitleColor(.darkG5, for: .highlighted)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var tableView = UITableView().then { view in
        view.separatorColor = .clear
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.id)
    }
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
