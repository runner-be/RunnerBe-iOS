//
//  SelectRunningFaceView.swift
//  Runner-be
//
//  Created by 이유리 on 1/28/24.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectRunningFaceView: SelectBaseView {
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

//    func select(idx: Int) {
//        reset()
//        switch idx {
//        case 0:
    ////            genderLabelGroup.toggle(label: genderNonLabel)
//            break
//        case 1:
//            genderLabelGroup.toggle(label: genderFemaleLabel)
//        case 2:
//            genderLabelGroup.toggle(label: genderMaleLabel)
//        default:
//            break
//        }
//    }

    func reset() {
//        if !genderNonLabel.isOn {
//            genderLabelGroup.toggle(label: genderNonLabel)
//        }
//
//        if genderFemaleLabel.isOn {
//            genderLabelGroup.toggle(label: genderFemaleLabel)
//        }
//
//        if genderMaleLabel.isOn {
//            genderLabelGroup.toggle(label: genderMaleLabel)
//        }
    }

    private lazy var vStackView = UIStackView.make(with: [
        beginnerCheckBoxWithLabel,
        averageCheckBoxWithLabel,
        intermediateCheckBoxWithLabel,
        masterCheckBoxWithLabel,
    ],
    axis: .vertical,
    alignment: .fill,
    distribution: .equalSpacing,
    spacing: 8)

    var beginnerCheckBoxWithLabel = CheckBoxView().then { view in
        view.labelText = L10n.RunningFace.beginner
        view.titleLabel.font = .pretendardSemiBold14
        view.titleLabel.textColor = .darkG2
    }

    var averageCheckBoxWithLabel = CheckBoxView().then { view in
        view.labelText = L10n.RunningFace.average
        view.titleLabel.font = .pretendardSemiBold14
        view.titleLabel.textColor = .darkG2
    }

    var intermediateCheckBoxWithLabel = CheckBoxView().then { view in
        view.labelText = L10n.RunningFace.high
        view.titleLabel.font = .pretendardSemiBold14
        view.titleLabel.textColor = .darkG2
    }

    var masterCheckBoxWithLabel = CheckBoxView().then { view in
        view.labelText = L10n.RunningFace.master
        view.titleLabel.font = .pretendardSemiBold14
        view.titleLabel.textColor = .darkG2
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.RunningFace.title

        contentView.addSubviews([
            vStackView,
        ])
    }

    override func initialLayout() {
        super.initialLayout()
    }
}
