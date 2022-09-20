//
//  RunnerBeMapView.swift
//  Runner-be
//
//  Created by 김신우 on 2022/06/20.
//

import MapKit
import RxSwift
import UIKit

class RunnerBeMapView: MKMapView {
    let regionWillChange = PublishSubject<Void>()
    let regionChanged = PublishSubject<(location: CLLocationCoordinate2D, radius: CLLocationDistance)>()
    let postSelected = PublishSubject<Int?>()

    private var postAnnotations: [PostAnnotation] = []

    var isAnnotationHidden: Bool = false {
        didSet {
            removeAnnotations(annotations)
            if isAnnotationHidden == false {
                addAnnotations(postAnnotations)
            }
        }
    }

    func setRegion(to coord: CLLocationCoordinate2D, radius: CLLocationDistance = 1000, animated: Bool = false) {
        centerToCoord(coord, regionRadius: radius, animated: animated)
    }

    func update(with posts: [Post], alwaysSelected: Bool = false) {
        removeAnnotations(annotations)
        postAnnotations = posts.compactMap { PostAnnotation(post: $0, alwaysSelected: alwaysSelected) }
        addAnnotations(postAnnotations)
    }

    init() {
        super.init(frame: .zero)
        delegate = self
        register(PostAnnotaionView.self, forAnnotationViewWithReuseIdentifier: PostAnnotaionView.identifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RunnerBeMapView: MKMapViewDelegate {
    func mapView(_: MKMapView, regionWillChangeAnimated animated: Bool) {
        if !animated {
            regionWillChange.onNext(())
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
            let location = mapView.centerCoordinate
            let radius = mapView.currentFrameRadius
            regionChanged.onNext((location: location, radius: radius))
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PostAnnotation,
              let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PostAnnotaionView.identifier, for: annotation) as? PostAnnotaionView
        else { return nil }
        annotationView.update(with: annotation)
        return annotationView
    }

    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? PostAnnotation else { return }
        postSelected.onNext(annotation.id)
    }

    func mapView(_: MKMapView, didDeselect _: MKAnnotationView) {
        postSelected.onNext(nil)
    }
}
