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
        update(with: item.runningState)
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

    let manageAttendanceButton = UILabel().then {
        $0.text = "출석 관리"
        $0.textColor = .darkG6
        $0.font = .pretendardSemiBold14
        $0.layer.backgroundColor = UIColor.primary.cgColor
        $0.layer.cornerRadius = 17
        $0.textAlignment = .center
    }

    let confirmAttendanceButton = UILabel().then {
        $0.text = "출석 확인하기"
        $0.textColor = .darkG6
        $0.font = .pretendardSemiBold14
        $0.layer.backgroundColor = UIColor.primary.cgColor
        $0.layer.cornerRadius = 17
        $0.textAlignment = .center
    }

    let writeLogButton = UILabel().then {
        $0.text = "로그 쓰기"
        $0.textColor = .darkG6
        $0.font = .pretendardSemiBold14
        $0.layer.backgroundColor = UIColor.primary.cgColor
        $0.layer.cornerRadius = 17
        $0.textAlignment = .center
    }

    let confirmLogButton = UILabel().then {
        $0.text = "로그 보기"
        $0.textColor = .darkG6
        $0.font = .pretendardSemiBold14
        $0.layer.backgroundColor = UIColor.primary.cgColor
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
            manageAttendanceButton,
            confirmAttendanceButton,
            writeLogButton,
            confirmLogButton,
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

        manageAttendanceButton.snp.makeConstraints {
            $0.top.equalTo(postInfoView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        confirmAttendanceButton.snp.makeConstraints {
            $0.top.equalTo(postInfoView.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalTo(contentView.snp.centerX).offset(-4)
            $0.bottom.equalToSuperview().inset(16)
        }

        writeLogButton.snp.makeConstraints {
            $0.top.equalTo(postInfoView.snp.bottom).offset(24)
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(contentView.snp.centerX).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }

        confirmLogButton.snp.makeConstraints {
            $0.top.equalTo(postInfoView.snp.bottom).offset(24)
            $0.right.equalToSuperview().inset(16)
            $0.left.equalTo(contentView.snp.centerX).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    func update(with state: RunningState) { // 상황에 따라 뷰 업데이트하는 부분
        statusLabel.isHidden = true
        manageAttendanceButton.isHidden = true
        confirmAttendanceButton.isHidden = true
        writeLogButton.isHidden = true
        confirmLogButton.isHidden = true

        switch state {
        case .participantDuringMeeting: // 참여자 모임참여(1) ~ 모임 중(6)
            statusLabel.text = "모임 후 로그를 관리할 수 있어요"
            statusLabel.isHidden = false
            postInfoView.statusLabel.label.text = "모집중"
            postInfoView.statusLabel.label.textColor = .primarydark

        case .creatorBeforeMeetingStart: // 작성자 모임작성(1) ~ 모임 시작 전(2)
            statusLabel.text = "모임 후 출석/로그를 관리할 수 있어요"
            statusLabel.isHidden = false
            postInfoView.statusLabel.label.text = "모집중"
            postInfoView.statusLabel.label.textColor = .primarydark

        case .creatorDuringMeetingBeforeEnd: // 작성자 모임시작(3) ~ 출석 진행(8)
            manageAttendanceButton.isHidden = false
            postInfoView.statusLabel.label.text = "모집 마감"
            postInfoView.statusLabel.label.textColor = .darkG3

        case .participantDuringMeetingBeforeEnd: // 참여자 모임시작(3) ~ 출석 진행(8)
            statusLabel.text = "모임 후 출석/로그를 관리할 수 있어요"
            statusLabel.isHidden = false
            postInfoView.statusLabel.label.text = "모집 마감"
            postInfoView.statusLabel.label.textColor = .darkG3

        case .attendanceClosed: // 출석 마감(9)
            confirmAttendanceButton.isHidden = false
            writeLogButton.isHidden = false
            postInfoView.statusLabel.label.text = "모임 종료"
            postInfoView.statusLabel.label.textColor = .darkG3

        case .logSubmissionClosed: // 로그 마감(10)
            confirmAttendanceButton.isHidden = false
            confirmLogButton.isHidden = false
            postInfoView.statusLabel.label.text = "모임 종료"
            postInfoView.statusLabel.label.textColor = .darkG3
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
