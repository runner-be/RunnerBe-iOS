//
//  SelectAfterPartyView.swift
//  Runner-be
//
//  Created by 이유리 on 3/20/24.
//

import UIKit

final class SelectAfterPartyView: SelectBaseView {
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
            afterPartyLabelGroup.toggle(label: afterPartyNonLabel)
        case 1:
            afterPartyLabelGroup.toggle(label: afterPartyYesLabel)
        default:
            break
        }
    }

    func reset() {
        if !afterPartyNonLabel.isOn {
            afterPartyLabelGroup.toggle(label: afterPartyNonLabel)
        }

        if afterPartyYesLabel.isOn {
            afterPartyLabelGroup.toggle(label: afterPartyYesLabel)
        }
    }

    var afterPartyNonLabel = OnOffLabel().then { label in
        label.text = "없음"
    }

    var afterPartyYesLabel = OnOffLabel().then { label in
        label.text = "있음"
    }

    var afterPartyLabelGroup = OnOffLabelGroup().then { group in

        group.styleOn = OnOffLabel.Style(
            font: .pretendardSemiBold14,
            backgroundColor: .primary,
            textColor: .darkG6,
            borderWidth: 1,
            borderColor: .primary,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        )

        group.styleOff = OnOffLabel.Style(
            font: .pretendardRegular14,
            backgroundColor: .clear,
            textColor: .darkG35,
            borderWidth: 1,
            borderColor: .darkG35,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        )

        group.maxNumberOfOnState = 1
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Afterparty.title

        contentView.addSubviews([
            afterPartyNonLabel,
            afterPartyYesLabel,
        ])

        afterPartyLabelGroup.append(labels: [
            afterPartyNonLabel,
            afterPartyYesLabel,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        afterPartyYesLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(24)
            make.leading.equalTo(contentView.snp.centerX).offset(6)
            make.bottom.equalTo(contentView.snp.bottom).offset(-24)
        }

        afterPartyNonLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(24)
            make.trailing.equalTo(contentView.snp.centerX).offset(-6)
            make.bottom.equalTo(contentView.snp.bottom).offset(-24)
        }
    }
}
