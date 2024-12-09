//
//  UserPageParticipateCell.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import RxSwift
import UIKit

class UserPageParticipateCell: UICollectionViewCell {
    // MARK: - Properties

    var disposeBag = DisposeBag()

    // MARK: - UI

    var postInfoView = BasicPostInfoView()

    // MARK: - Init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()
        postInfoView.reset()
    }

    // MARK: - Methods

    func configure(with item: UserPagePostConfig) {
        postInfoView.configure(with: item.cellConfig)
        update(with: item.runningState)
    }

    func update(with state: RunningState) {
        switch state {
        case .participantDuringMeeting: // 참여자 모임참여(1) ~ 모임 중(6)
            postInfoView.statusLabel.label.text = "모집중"
            postInfoView.statusLabel.label.textColor = .primarydark

        case .creatorBeforeMeetingStart: // 작성자 모임작성(1) ~ 모임 시작 전(2)
            postInfoView.statusLabel.label.text = "모집중"
            postInfoView.statusLabel.label.textColor = .primarydark

        case .creatorDuringMeetingBeforeEnd: // 작성자 모임시작(3) ~ 출석 진행(8)
            postInfoView.statusLabel.label.text = "모집 마감"
            postInfoView.statusLabel.label.textColor = .darkG3

        case .participantDuringMeetingBeforeEnd: // 참여자 모임시작(3) ~ 출석 진행(8)
            postInfoView.statusLabel.label.text = "모집 마감"
            postInfoView.statusLabel.label.textColor = .darkG3

        case .attendanceClosed: // 출석 마감(9)
            postInfoView.statusLabel.label.text = "모임 종료"
            postInfoView.statusLabel.label.textColor = .darkG3

        case .logSubmissionClosed: // 로그 마감(10)
            postInfoView.statusLabel.label.text = "모임 종료"
            postInfoView.statusLabel.label.textColor = .darkG3
        }
    }
}

// MARK: - Layout

extension UserPageParticipateCell {
    private func setup() {
        backgroundColor = .darkG55
        contentView.addSubviews([
            postInfoView,
        ])
    }

    private func initialLayout() {
        layer.cornerRadius = 12
        clipsToBounds = true

        postInfoView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview().inset(16)
        }
    }
}

extension UserPageParticipateCell {
    static let id: String = "\(UserPageParticipateCell.self)"

    static let size: CGSize = {
        let width = UIScreen.main.bounds.width - 40
        return CGSize(width: width, height: 150)
    }()
}
