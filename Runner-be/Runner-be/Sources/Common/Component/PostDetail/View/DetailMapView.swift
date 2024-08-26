//
//  DetailMapView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import MapKit
import RxCocoa
import RxSwift
import Then
import UIKit

class DetailMapView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(
        lat: Float,
        long: Float,
        range: Float,
        showMarker: Bool,
        locationInfo: String,
        placeExplain: String
    ) {
        let coord = CLLocationCoordinate2D(latitude: CGFloat(lat), longitude: CGFloat(long))
        let radius = range * 2
        mapView.centerToCoord(coord, regionRadius: CLLocationDistance(radius), animated: false)
        mapView.zoomToRadius(regionRadius: CLLocationDistance(radius), animated: false)

        if let circle = circleOverlay {
            mapView.removeOverlay(circle)
        }

        if showMarker {
            marker.isHidden = false
        } else {
            marker.isHidden = true

            let center = mapView.centerCoordinate
            let circleOverlay = MKCircle(center: center, radius: CLLocationDistance(range / 2))
            mapView.addOverlay(circleOverlay)

            self.circleOverlay = circleOverlay
        }

        locationInfoLabel.text = locationInfo
        placeExplainLabel.text = placeExplain
    }

    private var circleOverlay: MKCircle?
    private var marker = UIImageView().then { view in
        view.image = Asset.placeImage.uiImage
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        view.isHidden = true
    }

    lazy var mapView = MKMapView().then { view in
        view.isZoomEnabled = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.isUserInteractionEnabled = false
        view.delegate = self
    }

    private let detailInfoView = UIView().then {
        $0.backgroundColor = .darkG5
    }

    private let locationInfoLabel = UILabel().then {
        $0.font = .pretendardSemiBold14
        $0.textColor = .darkG2
    }

    private let placeExplainLabel = UILabel().then {
        $0.font = .pretendardRegular14
        $0.textColor = .darkG35
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 2
    }

    let copyButton = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .darkG55
        $0.setTitle("주소 복사", for: .normal)
        $0.setTitleColor(.darkG2, for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold10
    }

    private func setupViews() {
        addSubviews([
            mapView,
            marker,
            detailInfoView,
        ])

        detailInfoView.addSubviews([
            locationInfoLabel,
            placeExplainLabel,
            copyButton,
        ])
    }

    private func initialLayout() {
        mapView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(148)
        }

        marker.snp.makeConstraints { make in
            make.center.equalTo(mapView.snp.center)
        }

        detailInfoView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }

        locationInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(12)
            $0.right.equalTo(copyButton.snp.left).offset(-8)
        }

        placeExplainLabel.snp.makeConstraints {
            $0.top.equalTo(locationInfoLabel.snp.bottom).offset(4)
            $0.left.right.bottom.equalToSuperview().inset(12)
        }

        copyButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalTo(locationInfoLabel)
            $0.width.equalTo(52)
            $0.height.equalTo(22)
        }
    }
}

extension DetailMapView: MKMapViewDelegate {
    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = .primary
        circleRenderer.fillColor = .primary.withAlphaComponent(0.5)
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
}
