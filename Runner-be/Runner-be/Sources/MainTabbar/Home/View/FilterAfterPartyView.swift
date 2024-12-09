//
//  FilterAfterPartyView.swift
//  Runner-be
//
//  Created by 김창규 on 10/29/24.
//

import UIKit

final class FilterAfterPartyView: SelectBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
//        reset()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(idx: Int) {
//        reset()
        switch idx {
        case 0:
            afterPartyLabelGroup.toggle(label: afterPartyAllLabel)
        case 1:
            afterPartyLabelGroup.toggle(label: afterPartyYesLabel)
        case 2:
            afterPartyLabelGroup.toggle(label: afterPartyNonLabel)
        default:
            break
        }
    }

//    func reset() {
//        if !afterPartyAllLabel.isOn {
//            afterPartyLabelGroup.toggle(label: afterPartyAllLabel)
//        }
//
//        if afterPartyNonLabel.isOn {
//            afterPartyLabelGroup.toggle(label: afterPartyNonLabel)
//        }
//
//        if afterPartyYesLabel.isOn {
//            afterPartyLabelGroup.toggle(label: afterPartyYesLabel)
//        }
//    }

    var afterPartyAllLabel = OnOffLabel().then { label in
        label.text = "전체"
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
            afterPartyAllLabel,
            afterPartyYesLabel,
            afterPartyNonLabel,
        ])

        afterPartyLabelGroup.append(labels: [
            afterPartyAllLabel,
            afterPartyYesLabel,
            afterPartyNonLabel,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        afterPartyAllLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(24)
            $0.right.equalTo(afterPartyYesLabel.snp.left).offset(-12)
        }

        afterPartyYesLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }

        afterPartyNonLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(24)
            $0.left.equalTo(afterPartyYesLabel.snp.right).offset(12)
        }
    }
}
