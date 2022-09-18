//
//  PostAnnotationView.swift
//  Runner-be
//
//  Created by 김신우 on 2022/07/25.
//

import MapKit
import SnapKit
import Then
import UIKit

final class PostAnnotaionView: MKAnnotationView {
    static let identifier = "\(String(describing: PostAnnotaionView.self))"

    var markerView = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }

    lazy var selectedMarkerView = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(48)
        }

        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(12)
        }
    }

    let profileImageView = UIImageView().then { imageView in
        imageView.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(17)
        }
        imageView.image = Asset.profileEmptyIcon.uiImage
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        addSubviews([markerView, selectedMarkerView])
        markerView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
        }
        selectedMarkerView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
        }
        snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("\(#function) not defined")
    }

    func update(with annotation: PostAnnotation) {
        if let profileUrl = annotation.profileUrl {
            profileImageView.kf.setImage(with: URL(string: profileUrl), placeholder: Asset.profileEmptyIcon.uiImage)
        }
        setSelected(with: annotation, selected: annotation.isAlwaysSelected)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = Asset.profileEmptyIcon.uiImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let annotation = annotation as? PostAnnotation else { return }
        if isUserInteractionEnabled {
            setSelected(with: annotation, selected: selected)
        }
    }

    private func setSelected(with annotation: PostAnnotation, selected: Bool) {
        if selected {
            selectedMarkerView.isHidden = false
            markerView.isHidden = true
            selectedMarkerView.image = annotation.isOpen ? Asset.placeActiveSelected.uiImage : Asset.placeInactiveSelected.uiImage
        } else {
            selectedMarkerView.isHidden = true
            markerView.isHidden = false
            markerView.image = annotation.isOpen ? Asset.placeActive.uiImage : Asset.placeInactive.uiImage
        }
    }
}

final class PostAnnotation: NSObject, MKAnnotation {
    let isAlwaysSelected: Bool
    let id: Int
    let profileUrl: String?
    let coordinate: CLLocationCoordinate2D
    let isOpen: Bool

    init?(post: Post, alwaysSelected: Bool = false) {
        guard let lat = post.coord?.lat,
              let long = post.coord?.long
        else { return nil }
        id = post.ID
        coordinate = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
        profileUrl = post.writerProfileURL
        isOpen = post.open
        isAlwaysSelected = alwaysSelected
        super.init()
    }
}
