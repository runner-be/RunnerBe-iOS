//
//  DetailInfoView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import SnapKit
import Then
import UIKit

final class DetailInfoView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)

        setup()
        initialLayout()
    }

    func setup(
        date: String,
        afterParty _: String,
        time: String,
        numLimit: String,
        gender: String,
        age: String
    ) {
        dateLabel.label.text = date
        timeLabel.label.text = time
        genderLabel.label.text = gender
        participantLabel.text = numLimit
        ageLabel.text = age
    }

    private var dateLabel = IconLabel(iconPosition: .left, iconSize: CGSize(width: 24, height: 24), spacing: 8, padding: .zero).then { view in
        view.icon.image = Asset.scheduled.uiImage
        view.label.font = .pretendardRegular14
        view.label.textColor = .darkG35
        view.label.text = "M/DD (E) - HH:mm"
    }

    private var dotSeparator1 = UIView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(3)
        }
        view.backgroundColor = .darkG35
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
    }

    private var afterPartyLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG35
        label.text = "뒷풀이 없음"
    }

    private var timeLabel = IconLabel(iconPosition: .left, iconSize: CGSize(width: 24, height: 24), spacing: 8, padding: .zero).then { view in
        view.icon.image = Asset.time.uiImage
        view.label.font = .pretendardRegular14
        view.label.textColor = .darkG35
        view.label.text = "-시간 --분"
    }

    private var genderLabel = IconLabel(iconPosition: .left, iconSize: CGSize(width: 24, height: 24), spacing: 8, padding: .zero).then { view in
        view.icon.image = Asset.group.uiImage
        view.label.font = .pretendardRegular14
        view.label.textColor = .darkG35
        view.label.text = "-만"
    }

    private var dotSeparator2 = UIView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(3)
        }
        view.backgroundColor = .darkG35
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
    }

    private var ageLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG35
        label.text = "최소-최대"
    }

    private var dotSeparator3 = UIView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(3)
        }
        view.backgroundColor = .darkG35
        view.clipsToBounds = true
        view.layer.cornerRadius = 1.5
    }

    private var participantLabel = UILabel().then { label in
        label.font = .pretendardRegular14
        label.textColor = .darkG35
        label.text = "최대 -명"
    }

    private lazy var infoHStackView1 = UIStackView.make(
        with: [
            dateLabel,
            dotSeparator1,
            afterPartyLabel,
        ],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 8
    )

    private lazy var infoHStackView2 = UIStackView.make(
        with: [
            genderLabel,
            dotSeparator2,
            ageLabel,
            dotSeparator3,
            participantLabel,
        ],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 8
    )

    private lazy var vStackView = UIStackView.make(
        with: [
            infoHStackView1,
            timeLabel,
            infoHStackView2,
        ],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 6
    )

    func setup() {
        addSubviews([
            vStackView,
        ])
    }

    func initialLayout() {
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.lessThanOrEqualTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
