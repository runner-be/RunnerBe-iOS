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

    // https://cdn.discordapp.com/attachments/934610661974097980/945003205832622080/unknown.png
    var allowableBoundary: [CLLocationCoordinate2D] {
        [
            CLLocationCoordinate2D(latitude: 37.045668, longitude: 126.747340),
            CLLocationCoordinate2D(latitude: 37.805887, longitude: 127.473429),
        ]
    }

    func geoCodeLocation(at coord: CLLocationCoordinate2D) -> Observable<CLPlacemark?> {
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: L10n.locale) // KOREA

        let functionResult = ReplaySubject<CLPlacemark?>.create(bufferSize: 1)

        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { places, _ in
            functionResult.onNext(places?.last)
        }

        return functionResult
    }
}
