//
//  LocationService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/22.
//

import CoreLocation
import Foundation

protocol LocationService {
    var currentPlace: CLLocationCoordinate2D? { get }
}
