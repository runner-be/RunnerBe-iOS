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

    let profileImageView = UIImageView().then { imageView in
        imageView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        imageView.isHidden = true
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(6)
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
            image = annotation.isOpen ? Asset.placeActiveSelected.uiImage : Asset.placeInactiveSelected.uiImage
            profileImageView.isHidden = false
        } else {
            image = annotation.isOpen ? Asset.placeActive.uiImage : Asset.placeInactive.uiImage
            profileImageView.isHidden = true
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
