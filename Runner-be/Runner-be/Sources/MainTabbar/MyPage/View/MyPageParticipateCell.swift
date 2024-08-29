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
        update(with: item.myParticipateState)
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

    var statusLabel = UILabel().then {
        $0.font = .pretendardSemiBold14
        $0.textColor = .darkG4
        $0.layer.backgroundColor = UIColor.darkG5.cgColor
        $0.layer.cornerRadius = 17
        $0.textAlignment = .center
    }
}

extension MyPageParticipateCell {
    private func setup() {
        backgroundColor = Constants.backgroundColor
        contentView.addSubviews([
            postInfoView,
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

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(postInfoView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    func update(with state: MyParticipateState) { // 상황에 따라 뷰 업데이트하는 부분
        switch state {
        case .memberbeforeManage:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Participate.Before.title
        case .writerbeforeManage:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Writer.Before.title
        case .attendance:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Attendance.title
        case .absence:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Absence.title
        case .membernotManage:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Participate.NotCheck.title
        case .writernotManage:
            statusLabel.text = L10n.MyPage.MyRunning.Attendance.Writer.NotCheck.title
        }
    }
}

extension MyPageParticipateCell {
    static let id: String = "\(MyPageParticipateCell.self)"

    static let size: CGSize = {
        let width = UIScreen.main.bounds.width - 40
        let height: CGFloat = Constants.PostInfo.top
            + BasicPostInfoView.height
            + Constants.hDivider.top
            + Constants.statusLabel.top
            + Constants.statusLabel.bottom
            + 15 // 폰트크기
            + 1
        print("seijfsoefesf: \(height)")
        return CGSize(width: width, height: 208)
    }()
}
