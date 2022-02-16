//
//  FilterGenderView.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import Then
import UIKit

class FilterGenderView: FilterBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var genderNonLabel = OnOffLabel().then { label in
        label.text = L10n.Gender.none
    }

    var genderFemaleLabel = OnOffLabel().then { label in
        label.text = L10n.Gender.female
    }

    var genderMaleLabel = OnOffLabel().then { label in
        label.text = L10n.Gender.male
    }

    var genderLabelGroup = OnOffLabelGroup().then { group in

        group.styleOn = OnOffLabel.Style(
            font: .iosBody15B,
            backgroundColor: .primary,
            textColor: .darkG6,
            borderWidth: 1,
            borderColor: .primary,
            cornerRadiusRatio: 1,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.styleOff = OnOffLabel.Style(
            font: .iosBody15R,
            backgroundColor: .clear,
            textColor: .darkG35,
            borderWidth: 1,
            borderColor: .darkG35,
            cornerRadiusRatio: 1,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.maxNumberOfOnState = 1
    }

    override func setupViews() {
        super.setupViews()

        contentView.addSubviews([
            genderNonLabel,
            genderFemaleLabel,
            genderMaleLabel,
        ])

        genderLabelGroup.append(labels: [
            genderNonLabel,
            genderFemaleLabel,
            genderMaleLabel,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        genderFemaleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        genderNonLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.trailing.equalTo(genderFemaleLabel.snp.leading).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        genderMaleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(genderFemaleLabel.snp.trailing).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}
