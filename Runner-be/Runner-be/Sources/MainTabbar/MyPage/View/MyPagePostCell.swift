//
//  AttendablePostCell.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class MyPagePostCell: UICollectionViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    func configure(with item: MyPagePostConfig) { // 작성한 글 cell 내용 구성하는 부분
        postInfoView.configure(with: item.cellConfig)
        update(with: item.state)
    }

    override func prepareForReuse() {
        postInfoView.reset()
        disposeBag = DisposeBag()
    }

    enum Constants {
        static let backgroundColor: UIColor = .darkG55
        static let cornerRadius: CGFloat = 12
        static let marginX: CGFloat = 12

        enum PostInfo {
            static let top: CGFloat = 16
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
        }

        enum ManageButton { // 출석 관리/확인 버튼
            static let top: CGFloat = 20
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
            static let height: CGFloat = 36
            static let cornerRadius: CGFloat = Constants.ManageButton.height / 2.0

            static let bottom: CGFloat = 12 // not AutoLayout
        }
    }

    var disposeBag = DisposeBag()

    var postInfoView = BasicPostInfoView()

    var manageButton = UIButton().then { button in
//        button.setTitle(L10n.MyPage.Main.Cell.Button.Attend.title, for: .normal)
        button.setTitleColor(UIColor.darkG6, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

//        button.setTitle(L10n.MyPage.Main.Cell.Button.Attend.title, for: .disabled)
        button.setTitleColor(UIColor.darkG4, for: .disabled)
        button.setBackgroundColor(.darkG5, for: .disabled)
        button.layer.borderWidth = 0
//        button.layer.borderColor = UIColor.darkG4.cgColor

        button.titleLabel?.font = .iosBody13B
        button.clipsToBounds = true
    }
}

extension MyPagePostCell {
    private func setup() {
        backgroundColor = Constants.backgroundColor
        contentView.addSubviews([
            postInfoView,
            manageButton,
        ])
    }

    private func initialLayout() {
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true

        postInfoView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constants.PostInfo.top)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.PostInfo.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(Constants.PostInfo.trailing)
        }

        manageButton.snp.makeConstraints { make in
            make.top.equalTo(postInfoView.snp.bottom).offset(Constants.ManageButton.top)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.ManageButton.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(Constants.ManageButton.trailing)
            make.height.equalTo(Constants.ManageButton.height)
        }
        manageButton.layer.cornerRadius = Constants.ManageButton.cornerRadius
    }

    func update(with state: PostAttendState) { // 상황에 따라 뷰 업데이트하는 부분
        switch state {
        case .beforeManagable:
//            manageButton.backgroundColor = .darkG5
            manageButton.isEnabled = false
//            manageButton.setTitleColor(.darkG4, for: .disabled)
            manageButton.setTitle(L10n.MyPage.MyPost.Manage.Before.title, for: .disabled)
        case .managable:
//            manageButton.backgroundColor = .primary
            manageButton.isEnabled = true
//            manageButton.setTitleColor(.darkG6, for: .normal)
            manageButton.setTitle(L10n.MyPage.MyPost.Manage.After.title, for: .normal)
        case .afterManage:
//            manageButton.backgroundColor = .primary
            manageButton.isEnabled = true
//            manageButton.setTitleColor(.darkG6, for: .normal)
            manageButton.setTitle(L10n.MyPage.MyPost.Manage.Finished.title, for: .normal)
        }
    }
}

extension MyPagePostCell {
    static let id: String = "\(MyPagePostCell.self)"

    static let size: CGSize = {
        let width = UIScreen.main.bounds.width - Constants.marginX * 2
        let height: CGFloat = Constants.PostInfo.top
            + BasicPostInfoView.height
            + Constants.ManageButton.top
            + Constants.ManageButton.height
            + Constants.ManageButton.bottom

        return CGSize(width: width, height: height)
    }()
}
