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

    func setMapBoundary(with coords: [CLLocationCoordinate2D]) {
        mapView.cameraBoundary = MKMapView.CameraBoundary(mapRect: MKMapRect.makeRect(coordinates: coords))
    }

    func setMapCoord(_ coord: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000, animated: Bool) {
        mapView.centerToCoord(coord, regionRadius: regionRadius, animated: animated)
    }

    func showPlaceInfo(city: String, name: String) {
        placeLabel.isHidden = city.isEmpty && name.isEmpty
        placeLabel.texts = [city, name]
    }

    var locationChanged = PublishSubject<CLLocationCoordinate2D>()

    lazy var mapView = MKMapView().then { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.delegate = self
        view.isRotateEnabled = false
        view.isPitchEnabled = false
    }

    private var placeMark = UIImageView().then { view in
        view.image = Asset.placeImage.uiImage
        view.contentMode = .scaleAspectFit
    }

    private var placeLabel = BubbleLabel(direction: .left).then { label in
        label.bubbleColor = .darkG6
        label.bubbleBorderColor = .darkG6
        label.bubbleLineWidth = 0
        label.font = .iosBody13R
        label.fontSize = 13
        label.textColor = .darkG1
        label.padding = UIEdgeInsets(top: 6, left: 9, bottom: 9, right: 8)
        label.isHidden = true
    }

    private var infoLabel = UILabel().then { label in
        label.font = UIFont.iosBody13R
        label.text = L10n.Post.Place.Guide.readable
        label.textColor = .primarydark
        label.numberOfLines = 2
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Place.title

        contentView.addSubviews([
            mapView,
            infoLabel,
        ])

        mapView.addSubviews([
            placeMark,
            placeLabel,
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

        placeMark.snp.makeConstraints { make in
            make.centerX.equalTo(mapView.snp.centerX)
            make.centerY.equalTo(mapView.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        placeLabel.snp.makeConstraints { make in
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
