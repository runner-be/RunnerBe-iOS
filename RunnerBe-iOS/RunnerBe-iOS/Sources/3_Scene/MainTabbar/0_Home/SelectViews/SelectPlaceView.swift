//
//  SelectPlaceView.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/17.
//

import MapKit
import RxCocoa
import RxSwift
import Then
import UIKit

class SelectPlaceView: SelectBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        processingInputs()
        updateCircle()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func processingInputs() {
        mapView.rx.touchDownGesture()
            .when(.began)
            .subscribe(onNext: { [weak self] _ in
                guard let overlay = self?.circleOverlay else { return }
                self?.mapView.removeOverlay(overlay)
            })
            .disposed(by: disposeBag)
    }

    func setMapBoundary(with _: [CLLocationCoordinate2D]) {
//        mapView.cameraBoundary = MKMapView.CameraBoundary(mapRect: MKMapRect.makeRect(coordinates: coords))
    }

    func setMapCoord(_ coord: CLLocationCoordinate2D, animated: Bool) {
        mapView.centerToCoord(coord, regionRadius: slider.selectedMaxValue * 3, animated: animated)
        updateCircle()
    }

    lazy var mapView = MKMapView().then { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.isZoomEnabled = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.delegate = self
    }

    var offsetRange: CGFloat = 100
    private var circleOverlay: MKCircle?

    lazy var slider = Slider(leftHandle: CircularHandle(diameter: 16), rightHandle: CircularHandle(diameter: 16)).then { slider in

        var labelGroups = BasicSliderLabelGroup(valueFormatter: { "\(($0 / 1000).turncate(to: 1))" })
        labelGroups.moduloFactor = 1

        slider.sliderLabels = labelGroups
        slider.sliderType = .single

        slider.separatorStepEnable = true
        slider.separatorModulo = 500

        slider.maxValue = 3000
        slider.minValue = 500

        slider.enable = true

        slider.delegate = self
    }

    var unitLabel = UILabel().then { label in
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

    private func updateCircle() {
        if let circle = circleOverlay {
            mapView.removeOverlay(circle)
        }
        let center = mapView.centerCoordinate
        let range = slider.selectedMaxValue
        let circleOverlay = MKCircle(center: center, radius: range)
        mapView.addOverlay(circleOverlay)

        self.circleOverlay = circleOverlay
    }
}

extension SelectPlaceView: SliderDelegate {
    func didValueChaged(_: Slider, maxFrom _: CGFloat, maxTo _: CGFloat, minFrom: CGFloat, minTo: CGFloat) {
        if minFrom != minTo {
            mapView.zoomToRadius(regionRadius: minTo * 3, animated: true)
            updateCircle()
        }
    }
}

extension SelectPlaceView: MKMapViewDelegate {
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
