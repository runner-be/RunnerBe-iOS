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

    func setMapBoundary(with _: [CLLocationCoordinate2D]) {
//        mapView.cameraBoundary = MKMapView.CameraBoundary(mapRect: MKMapRect.makeRect(coordinates: coords))
    }

    func setMapCoord(_ coord: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000, animated: Bool) {
        mapView.centerToCoord(coord, regionRadius: regionRadius, animated: animated)
    }

    func showPlaceInfo(city: String, name: String) {
        placeLabel.isHidden = city.isEmpty && name.isEmpty
        placeLabel.text = city + "\n" + name
    }

    lazy var locationChanged = PublishSubject<CLLocationCoordinate2D>()

    lazy var mapView = MKMapView().then { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.delegate = self
        view.isRotateEnabled = false
        view.isPitchEnabled = false
    }

    var placeMark = UIImageView().then { view in
        view.image = Asset.placeImage.uiImage
        view.contentMode = .scaleAspectFit
    }

    var placeLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG1
        label.numberOfLines = 0
    }

    lazy var placeLabelBackground = UIView().then { view in
        view.backgroundColor = .darkG6
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        view.addSubviews([placeLabel])
        placeLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(9)
            make.trailing.equalTo(view.snp.trailing).offset(-8)
            make.top.equalTo(view.snp.top).offset(6)
            make.bottom.equalTo(view.snp.bottom).offset(-9)
        }
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Place.title

        contentView.addSubviews([
            mapView,
        ])

        mapView.addSubviews([
            placeMark,
            placeLabelBackground,
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

        placeMark.snp.makeConstraints { make in
            make.centerX.equalTo(mapView.snp.centerX)
            make.centerY.equalTo(mapView.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        placeLabelBackground.snp.makeConstraints { make in
            make.leading.equalTo(placeMark.snp.trailing)
            make.bottom.equalTo(placeMark.snp.top)
            make.trailing.lessThanOrEqualTo(mapView.snp.trailing).offset(-30)
        }
    }
}

extension WritingPlaceView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated _: Bool) {
        locationChanged.onNext(mapView.centerCoordinate)
    }
}
