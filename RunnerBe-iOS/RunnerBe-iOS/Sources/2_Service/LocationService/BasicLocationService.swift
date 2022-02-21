//
//  BasicLocationService.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/22.
//

import CoreLocation
import Foundation

class BasicLocationService: NSObject, LocationService {
    private var locationManager: CLLocationManager

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        setup()
    }

    private func setup() {
//        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    var currentPlace: CLLocationCoordinate2D? {
        locationManager.location?.coordinate
    }
}
