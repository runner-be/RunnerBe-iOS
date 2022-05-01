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

    func setup(lat: Float, long: Float, range: Float, showMarker: Bool) {
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

    private func setupViews() {
        addSubviews([
            mapView,
            marker,
        ])
    }

    private func initialLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }

        marker.snp.makeConstraints { make in
            make.center.equalTo(mapView.snp.center)
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
