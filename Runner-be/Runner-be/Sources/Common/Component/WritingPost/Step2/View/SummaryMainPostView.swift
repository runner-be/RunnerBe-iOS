//
//  SummaryMainPostView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import MapKit
import SnapKit
import Then
import UIKit

class SummaryMainPostView: UIView {
    typealias ConfigureData = (tag: String, title: String, date: String, time: String, location: CLLocationCoordinate2D, placeInfo: String)
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        processingInputs()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: WritingPostData) {
        badgeLabel.text = data.tag
        titleLabel.text = data.title
        dateLabel.label.text = data.dateString
        timeLabel.label.text = data.time
        mapView.centerToCoord(data.location, regionRadius: 300, animated: false)
        addressInfoView.label.text = data.placeInfo
    }

    private func processingInputs() {}

    private var mapView = MKMapView().then { view in
        view.isUserInteractionEnabled = false
    }

    private var markerImageView = UIImageView().then { view in
        view.image = Asset.placeImage.uiImage
        view.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
    }

    private var addressInfoView = IconLabel(iconPosition: .left, iconSize: CGSize(width: 18, height: 18)).then { view in
        view.icon.image = Asset.place.uiImage
        view.label.font = .iosBody13R
        view.label.textColor = .darkG3
        view.label.text = "동작구 사당1동"
        view.backgroundColor = .darkG55
    }

    private var badgeLabel = BadgeLabel().then { label in
        let padding = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
        label.applyStyle(
            BadgeLabel.Style(
                font: .textStyle.withSize(9),
                backgroundColor: .clear,
                textColor: .primarydarker,
                borderWidth: 1,
                borderColor: .primarydarker,
                cornerRadiusRatio: 1,
                useCornerRadiusAsFactor: true,
                padding: padding
            )
        )
        label.text = "출근 전"
    }

    private var titleLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG25
        label.text = "새벽에 달리기 하실분? 새벽에 달리기 하실분?"
    }

    private var dateLabel = IconLabel(iconPosition: .left, iconSize: CGSize(width: 18, height: 18)).then { view in
        view.icon.image = Asset.scheduled.uiImage
        view.label.font = .iosBody13R
        view.label.textColor = .darkG3
        view.label.text = "3/31 (금) AM 6:00"
    }

    private var pointLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG3
        label.text = "·"
    }

    private var timeLabel = IconLabel(iconPosition: .left, iconSize: CGSize(width: 18, height: 18)).then { view in
        view.icon.image = Asset.time.uiImage
        view.label.font = .iosBody13R
        view.label.textColor = .darkG3
        view.label.text = "20분 소요"
    }

    private func setupViews() {
        addSubviews([
            mapView,
            markerImageView,
            badgeLabel,
            titleLabel,
            dateLabel,
            pointLabel,
            timeLabel,
        ])

        mapView.addSubview(addressInfoView)
    }

    private func initialLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(88)
            make.width.equalTo(110)
            make.bottom.equalTo(self.snp.bottom)
        }
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 5

        markerImageView.snp.makeConstraints { make in
            make.centerX.equalTo(mapView.snp.centerX)
            make.bottom.equalTo(mapView.snp.centerY)
        }

        addressInfoView.snp.makeConstraints { make in
            make.leading.equalTo(mapView.snp.leading)
            make.trailing.equalTo(mapView.snp.trailing)
            make.bottom.equalTo(mapView.snp.bottom)
        }

        badgeLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top)
            make.leading.equalTo(mapView.snp.trailing).offset(18)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(badgeLabel.snp.leading)
            make.top.equalTo(badgeLabel.snp.bottom).offset(4)
            make.trailing.equalTo(self.snp.trailing)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
        }
    }
}
