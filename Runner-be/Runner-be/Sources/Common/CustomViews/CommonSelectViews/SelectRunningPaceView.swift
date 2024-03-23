//
//  SelectRunningPaceView.swift
//  Runner-be
//
//  Created by 이유리 on 3/20/24.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectRunningPaceView: SelectBaseView {
    var selected = "" {
        didSet {
            [beginnerView, averageView, highView, masterView].forEach { view in
                if view.isOn {
                    view.isOn = false
                }
            }
        }
    }

    var infoLogo = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        view.image = Asset.circleInfo.uiImage
    }

    var infoWordBubble = UIImageView().then { view in
        view.image = Asset.writePostRunningPaceWordbubble.image
        let label = UILabel()
        label.font = .pretendardRegular12
        label.textColor = .primary
        label.text = L10n.RunningPace.Info.description

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.bottom.trailing.equalToSuperview().offset(-12)
        }
        view.isHidden = true

        view.snp.makeConstraints { make in
            make.width.equalTo(193)
            make.height.equalTo(64)
        }
    }

    private lazy var vStackView = UIStackView.make(
        with: [
            beginnerView,
            averageView,
            highView,
            masterView,
        ],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 32
    )

    var beginnerView = OnOffLabelWithRadioButton().then { view in
        view.label.icon.image = Asset.runningPaceBeginner.image
        view.label.label.text = L10n.RunningPace.Beginner.title
    }

    var averageView = OnOffLabelWithRadioButton().then { view in
        view.label.icon.image = Asset.runningPaceAverage.image
        view.label.label.text = L10n.RunningPace.Average.title
    }

    var highView = OnOffLabelWithRadioButton().then { view in
        view.label.icon.image = Asset.runningPaceHigh.image
        view.label.label.text = L10n.RunningPace.High.title
    }

    var masterView = OnOffLabelWithRadioButton().then { view in
        view.label.icon.image = Asset.runningPaceMaster.image
        view.label.label.text = L10n.RunningPace.Master.title
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.RunningPace.title

        contentView.addSubviews([
            infoLogo,
            infoWordBubble,
            vStackView,
        ])

        contentView.bringSubviewToFront(infoWordBubble)
    }

    override func initialLayout() {
        super.initialLayout()

        infoLogo.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
        }

        infoWordBubble.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        vStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
