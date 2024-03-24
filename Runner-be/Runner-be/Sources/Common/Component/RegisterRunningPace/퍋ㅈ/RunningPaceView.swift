//
//  RunningPaceView.swift
//  Runner-be
//
//  Created by 이유리 on 2/12/24.
//

import SnapKit
import Then
import UIKit

enum RunningPaceViewType {
    case userInfo
    case myPage
}

final class RunningPaceView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var icon = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }

    var label = UILabel().then { view in
        view.textColor = .darkG1
    }

    func configure(pace: String, viewType: RunningPaceViewType) {
        switch pace {
        case "beginner":
            icon.image = Asset.runningPaceBeginner.image
            label.text = L10n.RunningPace.Beginner.title
        case "average":
            icon.image = Asset.runningPaceAverage.image
            label.text = L10n.RunningPace.Average.title
        case "high":
            icon.image = Asset.runningPaceHigh.image
            label.text = L10n.RunningPace.High.title
        case "master":
            icon.image = Asset.runningPaceMaster.image
            label.text = L10n.RunningPace.Master.title
        default:
            break
        }

        switch viewType {
        case .myPage:
            label.font = .pretendardRegular14

            icon.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top).offset(4)
                make.bottom.equalTo(self.snp.bottom).offset(-4)
                make.leading.equalTo(self.snp.leading).offset(8)
            }

            label.snp.makeConstraints { make in
                make.leading.equalTo(icon.snp.trailing).offset(2)
                make.centerY.equalTo(icon.snp.centerY)
                make.trailing.equalTo(self.snp.trailing).offset(-8)
            }
        case .userInfo:
            label.font = .pretendardRegular10

            icon.snp.makeConstraints { make in
                make.top.equalTo(self.snp.top).offset(2)
                make.bottom.equalTo(self.snp.bottom).offset(-2)
                make.leading.equalTo(self.snp.leading).offset(2)
            }

            label.snp.makeConstraints { make in
                make.leading.equalTo(icon.snp.trailing).offset(2)
                make.centerY.equalTo(icon.snp.centerY)
                make.trailing.equalTo(self.snp.trailing).offset(-4)
            }
        }
    }
}

extension RunningPaceView {
    func setupViews() {
        layer.cornerRadius = 4
        layer.masksToBounds = true
        backgroundColor = .darkG45

        addSubviews([
            icon,
            label,
        ])
    }
}
