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

    func setup(place _: String, date _: String, time _: String, numLimit _: Int, gender _: String, age _: String) {}

    private var placeLabel = IconLabel().then { view in
        view.icon.image = Asset.place.uiImage
        view.iconSize = CGSize(width: 24, height: 24)
        view.label.font = .iosBody15R
        view.label.textColor = .darkG1
        view.label.text = "PLACE INFO"
        view.spacing = 8
    }

    private var dateLabel = IconLabel().then { view in
        view.icon.image = Asset.scheduled.uiImage
        view.iconSize = CGSize(width: 24, height: 24)
        view.label.font = .iosBody15R
        view.label.textColor = .darkG1
        view.label.text = "M/d (E) a h:mm"
        view.spacing = 8
    }

    private var timeLabel = IconLabel().then { view in
        view.icon.image = Asset.time.uiImage
        view.iconSize = CGSize(width: 24, height: 24)
        view.label.font = .iosBody15R
        view.label.textColor = .darkG1
        view.label.text = "m분"
        view.spacing = 8
    }

    private var genderLabel = IconLabel().then { view in
        view.icon.image = Asset.group.uiImage
        view.iconSize = CGSize(width: 24, height: 24)
        view.label.font = .iosBody15R
        view.label.textColor = .darkG1
        view.label.text = "GENDER"
        view.spacing = 8
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

    private var ageLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = "MIN-MAX"
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

    private var participantLabel = UILabel().then { label in
        label.font = .iosBody15R
        label.textColor = .darkG1
        label.text = "최대 ~ 명"
    }

    private lazy var infoStackView = UIStackView.make(
        with: [
            genderLabel,
            dotSeparator1,
            ageLabel,
            dotSeparator2,
            participantLabel,
        ],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 8
    )

    private lazy var vStackView = UIStackView.make(
        with: [
            placeLabel,
            dateLabel,
            timeLabel,
            infoStackView,
        ],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 4
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
