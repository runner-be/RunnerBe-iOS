//
//  RunnerBeMapView.swift
//  Runner-be
//
//  Created by 김신우 on 2022/06/20.
//

import MapKit
import UIKit

class RunnerBeMapView: MKMapView {}

extension RunnerBeMapView: MKMapViewDelegate {
    func mapView(_: MKMapView, regionWillChangeAnimated _: Bool) {}

    func mapViewDidChangeVisibleRegion(_: MKMapView) {}

    func mapView(_: MKMapView, regionDidChangeAnimated _: Bool) {}
}
