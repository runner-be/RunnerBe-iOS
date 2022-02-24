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

    lazy var mapView = MKMapView().then { view in
        view.isZoomEnabled = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.isUserInteractionEnabled = false
        view.delegate = self
    }

    var offsetRange: CGFloat = 100
    private var circleOverlay: MKCircle?

    func setupViews() {
        addSubviews([
            mapView,
        ])
    }

    func initialLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }

    private func updateCircle() {
//        if let circle = circleOverlay {
//            mapView.removeOverlay(circle)
//        }
//        let center = mapView.centerCoordinate
//        let circleOverlay = MKCircle(center: center, radius: range)
//        mapView.addOverlay(circleOverlay)
//
//        self.circleOverlay = circleOverlay
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

    func mapView(_: MKMapView, regionDidChangeAnimated _: Bool) {
        updateCircle()
    }
}
