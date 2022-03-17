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

    var enableStateOb = ReplaySubject<Bool>.create(bufferSize: 1)
    var locationEnableState: Observable<Bool> {
        return enableStateOb
    }

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        setup()
    }

    private func setup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    private let defaultPlace = CLLocationCoordinate2D(latitude: 37.5662952, longitude: 126.9735677)

    var currentPlace: CLLocationCoordinate2D {
        switch locationManager.authorizationStatus {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            return locationManager.location?.coordinate ?? defaultPlace
        default:
            return defaultPlace
        }
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

extension BasicLocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let enable: Bool
        switch manager.authorizationStatus {
        case .notDetermined:
            enable = false
        case .restricted:
            enable = false
        case .denied:
            enable = false
        case .authorizedAlways:
            enable = true
        case .authorizedWhenInUse:
            enable = true
        @unknown default:
            enable = false
        }
        enableStateOb.onNext(enable)
    }
}
