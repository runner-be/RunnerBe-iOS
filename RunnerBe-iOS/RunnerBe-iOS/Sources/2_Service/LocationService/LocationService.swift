//
//  LocationService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/22.
//

import CoreLocation
import Foundation
import RxSwift

protocol LocationService {
    var currentPlace: CLLocationCoordinate2D? { get }
    func geoCodeLocation(at coord: CLLocationCoordinate2D) -> Observable<CLPlacemark?>
}
