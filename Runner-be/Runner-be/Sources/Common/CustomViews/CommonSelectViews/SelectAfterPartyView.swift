//
//  SelectAfterPartyView.swift
//  Runner-be
//
//  Created by 이유리 on 1/28/24.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectAfterPartyView: SelectBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        reset()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(idx: Int) {
        reset()
        switch idx {
        case 0:
//            genderLabelGroup.toggle(label: genderNonLabel)
            break
        case 1:
            genderLabelGroup.toggle(label: afterPartyYesLabel)
        case 2:
            genderLabelGroup.toggle(label: afterPartyNoLabel)
        default:
            break
        }
    }

    func reset() {
        if !afterPartyAllLabel.isOn {
            genderLabelGroup.toggle(label: afterPartyAllLabel)
        }

        if afterPartyYesLabel.isOn {
            genderLabelGroup.toggle(label: afterPartyYesLabel)
        }

        if afterPartyNoLabel.isOn {
            genderLabelGroup.toggle(label: afterPartyNoLabel)
        }
    }

    var afterPartyAllLabel = OnOffLabel().then { label in
        label.text = "전체"
    }

    var afterPartyYesLabel = OnOffLabel().then { label in
        label.text = "있음"
    }

    var afterPartyNoLabel = OnOffLabel().then { label in
        label.text = "없음"
    }

    var genderLabelGroup = OnOffLabelGroup().then { group in

        group.styleOn = OnOffLabel.Style(
            font: .iosBody15B,
            backgroundColor: .primary,
            textColor: .darkG6,
            borderWidth: 1,
            borderColor: .primary,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.styleOff = OnOffLabel.Style(
            font: .iosBody15R,
            backgroundColor: .clear,
            textColor: .darkG35,
            borderWidth: 1,
            borderColor: .darkG35,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.maxNumberOfOnState = 1
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.RunningFace.title

        contentView.addSubviews([
            afterPartyAllLabel,
            afterPartyYesLabel,
            afterPartyNoLabel,
        ])

        genderLabelGroup.append(labels: [
            afterPartyAllLabel,
            afterPartyYesLabel,
            afterPartyNoLabel,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        afterPartyYesLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        afterPartyAllLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.trailing.equalTo(afterPartyYesLabel.snp.leading).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        afterPartyNoLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(afterPartyYesLabel.snp.trailing).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}
