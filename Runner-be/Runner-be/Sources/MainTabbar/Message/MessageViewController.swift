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

    private func viewInputs() { // 얘는 이벤트가 들어오되 뷰모델을 거치지 않아도 되는애들
    }

    private func viewModelInput() { // 얘는 이벤트가 뷰모델로 전달이 되어야할 때 쓰는 애들
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
    } // 뷰모델에서 뷰로 데이터가 전달되어 뷰의 변화가 반영되는 부분

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
