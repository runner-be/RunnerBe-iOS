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
    let db = Firestore.firestore()
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewInputs()
        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MessageChatViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageChatViewModel

    private func viewInputs() { // 얘는 이벤트가 들어오되 뷰모델을 거치지 않아도 되는애들
    }

    private func viewModelInput() { // 얘는 이벤트가 뷰모델로 전달이 되어야할 때 쓰는 애들
    }

    private func viewModelOutput() { // 뷰모델에서 뷰로 데이터가 전달되어 뷰의 변화가 반영되는 부분
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 12
    }

    private var postSection = MessagePostView()

    private var talkedLabel = UILabel().then { view in
        view.textColor = .darkG35
        view.font = .iosBody13R
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG6
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
            talkedLabel,
            hDivider,
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

        talkedLabel.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.leading.equalTo(self.view.snp.leading).offset(16)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(talkedLabel.snp.bottom).offset(16)
            make.leading.equalTo(self.view.snp.leading).offset(16)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
            make.height.equalTo(1)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(8)
            make.leading.equalTo(self.view.snp.leading).offset(16)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
        }
    }
}

extension MessageChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageChatTableViewCell.id) as? MessageChatTableViewCell else { return .init() }

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
