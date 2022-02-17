//
//  FilterPlaceView.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/17.
//

import MapKit
import RxCocoa
import RxSwift
import Then
import UIKit

class FilterPlaceView: FilterBaseView {
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

    private func processingInputs() {}

    private var mapView = MKMapView().then { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
    }

    private var slider = Slider(leftHandle: CircularHandle(diameter: 16), rightHandle: CircularHandle(diameter: 16)).then { slider in

        var labelGroups = BasicSliderLabelGroup(valueFormatter: { "\(($0 / 1000).turncate(to: 1))" })
        labelGroups.moduloFactor = 1

        slider.sliderLabels = labelGroups
        slider.sliderType = .single

        slider.separatorStepEnable = true
        slider.separatorModulo = 500

        slider.maxValue = 3000
        slider.minValue = 500

        slider.enable = true
    }

    private var unitLabel = UILabel().then { label in
        label.font = UIFont.iosBody13R
        label.text = "(km)"
        label.textColor = .darkG4
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Place.title

        contentView.addSubviews([
            mapView,
            slider,
            unitLabel,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        mapView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.height.equalTo(228)
        }

        slider.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        unitLabel.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}
