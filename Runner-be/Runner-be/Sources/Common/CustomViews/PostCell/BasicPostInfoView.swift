//
//  BasicPostInfoView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import KakaoSDKCommon
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BasicPostInfoView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    func configure(
        with item: PostCellConfig,
        backgroundColor _: UIColor = .darkG55
    ) {
        bookMarkIcon.isSelected = item.bookmarked
        titleLabel.text = item.title
        dateLabel.label.text = item.date
        participantLabel.text = "\(item.gender) · \(item.ageText)"
        bookMarkIcon.isSelected = item.bookmarked
        afterPartyLabel.text = item.afterParty == 1 ? "뒷풀이 있음" : "뒷풀이 없음"
        runningPaceView.configure(
            pace: item.pace,
            viewType: .postDetail
        )

        update(with: item.runningState)
        //        if item.peopleNum == item.attendanceProfiles.count {
        //            statusLabel.label.text = "모집 마감"
        //            statusLabel.label.textColor = .darkG3
        //        } else {
        //            statusLabel.label.textColor = .primarydark
        //            statusLabel.label.text = "모집중"
        //        }
    }

    func configure(with item: UserPostCellConfig) {
        bookMarkIcon.isHidden = true
        titleLabel.text = item.title
        dateLabel.label.text = item.date
        participantLabel.text = item.age
        afterPartyLabel.text = item.afterParty == 1 ? "뒷풀이 있음" : "뒷풀이 없음"

        runningPaceView.configure(
            pace: item.pace,
            viewType: .postDetail
        )
    }

    func configure(with item: PostConfig) {
        bookMarkIcon.isSelected = item.bookmarked
        titleLabel.text = item.title
        dateLabel.label.text = item.date
        participantLabel.text = "\(item.gender) · \(item.ageText)"
        bookMarkIcon.isSelected = item.bookmarked
        afterPartyLabel.text = item.afterParty == 1 ? "뒷풀이 있음" : "뒷풀이 없음"
        runningPaceView.configure(
            pace: item.pace,
            viewType: .postDetail
        )
        update(with: item.runningState)
    }

    func update(with state: RunningState) { // 상황에 따라 뷰 업데이트하는 부분
        switch state {
        case .participantDuringMeeting: // 참여자 모임참여(1) ~ 모임 중(6)
            statusLabel.label.text = "모집중"
            statusLabel.label.textColor = .primarydark
        case .creatorBeforeMeetingStart: // 작성자 모임작성(1) ~ 모임 시작 전(2)
            statusLabel.label.text = "모집중"
            statusLabel.label.textColor = .primarydark
        case .creatorDuringMeetingBeforeEnd: // 작성자 모임시작(3) ~ 출석 진행(8)
            statusLabel.label.text = "모집 마감"
            statusLabel.label.textColor = .darkG3
        case .participantDuringMeetingBeforeEnd: // 참여자 모임시작(3) ~ 출석 진행(8)
            statusLabel.label.text = "모집 마감"
            statusLabel.label.textColor = .darkG3
        case .attendanceClosed: // 출석 마감(9)
            statusLabel.label.text = "모임 종료"
            statusLabel.label.textColor = .darkG3
        case .logSubmissionClosed: // 로그 마감(10)
            statusLabel.label.text = "모집 종료"
            statusLabel.label.textColor = .darkG3
        }
    }

    func reset() {
        bookMarkIcon.isSelected = false
    }

    enum Constants {
        enum BookMark {}

        enum Title {
            static let height: CGFloat = 22
            static let font: UIFont = .pretendardBold16
            static let textColor: UIColor = .darkG1
        }

        enum Profile {
            static let top: CGFloat = 14

            static let dimension: CGFloat = 0
            static let spacing: CGFloat = -8
            static let borderWidth: CGFloat = 2
            static let cornerRadius: CGFloat = dimension / 2.0
        }

        enum InfoLabel {
            static let iconSize: CGSize = .init(width: 20, height: 20)
            static let spacing: CGFloat = 8

            static let font: UIFont = .iosBody13R
            static let textColor: UIColor = .darkG2

            enum Date {
                static let top: CGFloat = 16
            }

            enum Participant {
                static let leading: CGFloat = 40
            }

            enum Time {
                static let top: CGFloat = 4
            }
        }
    }

    var bookMarkIcon = UIButton().then {
        $0.setImage(Asset.bookmarkTabIconNormal.uiImage, for: .normal)
        $0.setImage(Asset.bookmarkTabIconFocused.uiImage, for: .selected)
    }

    private var titleLabel = UILabel().then {
        $0.font = .pretendardSemiBold16
        $0.textColor = .darkG1
        $0.text = "PostTitlePlaceHolder"
    }

    let statusLabel = IconLabel(
        iconSize: CGSize(width: 16, height: 16),
        spacing: 6
    ).then {
        $0.label.font = .pretendardRegular14
        $0.label.textColor = .primarydark
        $0.label.text = "모집중"
        $0.icon.image = Asset.group.uiImage
    }

    private var dateLabel = IconLabel(
        iconSize: CGSize(width: 16, height: 16),
        spacing: 6
    ).then {
        $0.label.font = .pretendardRegular14
        $0.label.textColor = .darkG3
        $0.label.text = "3/31 (금) AM 6:00"
        $0.icon.image = Asset.scheduled.uiImage
    }

    private var participantLabel = UILabel().then {
        $0.font = .pretendardRegular14
        $0.textColor = .darkG3
        $0.text = "여성 · 20-35"
    }

    private var afterPartyLabel = UILabel().then {
        $0.font = .pretendardRegular14
        $0.textColor = .darkG3
        $0.text = "뒷풀이 없음"
    }

    private var runningPaceView = RunningPaceView()
}

extension BasicPostInfoView {
    private func setup() {
        backgroundColor = .clear
        addSubviews([
            bookMarkIcon,
            titleLabel,
            statusLabel,
            participantLabel,
            dateLabel,
            afterPartyLabel,
            runningPaceView,
        ])
    }

    private func initialLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.equalTo(22)
        }

        bookMarkIcon.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.left.equalTo(titleLabel.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.size.equalTo(24)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(titleLabel)
            $0.height.equalTo(22)
        }

        participantLabel.snp.makeConstraints {
            $0.left.equalTo(statusLabel.snp.right).offset(8)
            $0.centerY.equalTo(statusLabel)
            $0.height.equalTo(22)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(participantLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.height.equalTo(22)
        }

        afterPartyLabel.snp.makeConstraints {
            $0.left.equalTo(dateLabel.snp.right).offset(6)
            $0.centerY.equalTo(dateLabel)
            $0.height.equalTo(22)
        }

        runningPaceView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.left.equalTo(titleLabel)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
}

extension BasicPostInfoView {
    static var height: CGFloat {
        let infoLabelHeight = IconLabel.Size(iconSize: Constants.InfoLabel.iconSize, text: "abc", font: Constants.InfoLabel.font, spacing: Constants.InfoLabel.spacing).height

        // FIXME: 고정값말고 옽 레이아웃 잡기
        let titleHeight = 24.0
        let contentHeight = 48.0
        let paceHeight = 30.0
        let spacing = 16.0
        return titleHeight + contentHeight + paceHeight + spacing
    }
}
