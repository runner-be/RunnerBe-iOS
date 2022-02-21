//
//  MKMapView+.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/22.
//

import Foundation
import MapKit

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000, animated: Bool = false) {
        let coordRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordRegion, animated: animated)
    }

    func centerToCoord(_ coord: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000, animated: Bool) {
        let coordRegion = MKCoordinateRegion(
            center: coord,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )

        setRegion(coordRegion, animated: animated)
    }

    func zoomToRadius(regionRadius: CLLocationDistance, animated: Bool) {
        let center = centerCoordinate
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(region, animated: animated)
    }
}
