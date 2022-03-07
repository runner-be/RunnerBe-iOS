//
//  SelectAgeView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectAgeView: SelectBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        processingInputs()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValues(minValue: CGFloat, maxValue: CGFloat) {
        slider.setSelectValue(minValue: minValue, maxValue: maxValue)
    }

    func reset() {
        slider.reset()
        checkBox.isSelected = false
    }

    private func processingInputs() {
        checkBox.tapCheck
            .map { !$0 }
            .subscribe(onNext: { [weak self] enable in
                self?.slider.enable = enable
            })
            .disposed(by: disposeBag)
    }

    var checkBox = CheckBoxView().then { view in
        view.leftBox = false
        view.labelText = L10n.Home.Filter.Age.all
        view.moreInfoButton.isHidden = true
        view.checkBoxButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG35
        view.titleLabel.font = .iosBody13R
        view.spacing = 5
        view.isSelected = false
    }

    var slider = Slider(leftHandle: CircularHandle(diameter: 16), rightHandle: CircularHandle(diameter: 16)).then { slider in
        let rightFollower = BubbleFollower()
        rightFollower.moreThanMax = true
        slider.showRightFollower = true
        slider.rightHandleFollower = rightFollower

        var labelGroups = BasicSliderLabelGroup(valueFormatter: { "\(Int($0))" })
        labelGroups.maxValueFormatter = { "\(Int($0))↑" }
        labelGroups.moduloFactor = 2

        slider.sliderLabels = labelGroups
        slider.sliderType = .range

        slider.separatorStepEnable = true
        slider.separatorModulo = 5

        slider.maxValue = 65
        slider.minValue = 20

        slider.enable = true
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Age.title

        addSubviews([
            checkBox,
        ])

        contentView.addSubviews([
            slider,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        checkBox.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
        }

        slider.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(25)
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.trailing.equalTo(contentView.snp.trailing).offset(-23)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}
