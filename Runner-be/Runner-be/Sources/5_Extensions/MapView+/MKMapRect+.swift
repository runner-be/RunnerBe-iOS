//
//  MKMapView+.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import Foundation
import MapKit

extension MKMapRect {
    static func makeRect(coordinates: [CLLocationCoordinate2D]) -> MKMapRect {
        var rect = MKMapRect()
        var coordinates = coordinates
        if !coordinates.isEmpty {
            let first = coordinates.removeFirst()
            var top = first.latitude
            var bottom = first.latitude
            var left = first.longitude
            var right = first.longitude
            coordinates.forEach { coordinate in
                top = max(top, coordinate.latitude)
                bottom = min(bottom, coordinate.latitude)
                left = min(left, coordinate.longitude)
                right = max(right, coordinate.longitude)
            }
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude: top, longitude: left))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude: bottom, longitude: right))
            rect = MKMapRect(x: topLeft.x, y: topLeft.y,
                             width: bottomRight.x - topLeft.x, height: bottomRight.y - topLeft.y)
        }
        return rect
    }
}
