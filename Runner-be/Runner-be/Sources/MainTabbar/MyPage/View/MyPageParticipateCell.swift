//
//  MyPageParticipateCell.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/03.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class MyPageParticipateCell: UICollectionViewCell {
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

        enum hDivider {
            static let top: CGFloat = 16
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
        }

        enum statusLabel {
            static let top: CGFloat = 12
            static let bottom: CGFloat = 12
        }
    }

    var disposeBag = DisposeBag()

    var postInfoView = BasicPostInfoView()

    var hDivider = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    var statusLabel = UILabel().then { make in
        make.font = .iosBody15R
//        make.text = "hi"
        make.textColor = .darkG35
    }
}

extension MyPageParticipateCell {
    private func setup() {
        backgroundColor = Constants.backgroundColor
        contentView.addSubviews([
            postInfoView,
            hDivider,
            statusLabel,
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

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(postInfoView.snp.bottom).offset(Constants.hDivider.top)
            make.leading.equalTo(contentView.snp.leading).offset(Constants.hDivider.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(Constants.hDivider.trailing)
            make.height.equalTo(1)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(Constants.statusLabel.top)
            make.centerX.equalTo(hDivider.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }

    func update(with state: PostAttendState) { // 상황에 따라 뷰 업데이트하는 부분
        switch state {
        case .beforeManagable: break
        case .managable: break
        case .afterManage: break
        case .beforeManage:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Before.title
        case .attendance:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Attendance.title
        case .absence:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Absence.title
        case .notManage:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.NotCheck.title
        }
    }
}

extension MyPageParticipateCell {
    static let id: String = "\(MyPageParticipateCell.self)"

    static let size: CGSize = {
        let width = UIScreen.main.bounds.width - Constants.marginX * 2
        let height: CGFloat = Constants.PostInfo.top
            + BasicPostInfoView.height
            + Constants.hDivider.top
            + Constants.statusLabel.top
            + Constants.statusLabel.bottom
            + 15 // 폰트크기
            + 1

        return CGSize(width: width, height: height)
    }()
}
