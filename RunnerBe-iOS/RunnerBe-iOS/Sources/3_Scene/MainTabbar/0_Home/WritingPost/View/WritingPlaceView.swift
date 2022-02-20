//
//  WritingPlaceView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/19.
//

import MapKit
import RxCocoa
import RxSwift
import Then
import UIKit

class WritingPlaceView: SelectBaseView {
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

    private var infoLabel = UILabel().then { label in
        label.font = UIFont.iosBody13R
        label.text = L10n.Post.Place.Guide.readable
        label.textColor = .primarydark
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Place.title

        contentView.addSubviews([
            mapView,
            infoLabel,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        mapView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(228)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
}
