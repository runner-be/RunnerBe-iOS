//
//  BasicLocationService.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/22.
//

import CoreLocation
import Foundation
import RxSwift

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

    func geoCodeLocation(at coord: CLLocationCoordinate2D) -> Observable<CLPlacemark?> {
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: L10n.locale) // KOREA
        
        let functionResult = ReplaySubject<CLPlacemark?>.create(bufferSize: 1)
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { places, error in
            functionResult.onNext(places?.last)
        }
        
        return functionResult
    }
}
