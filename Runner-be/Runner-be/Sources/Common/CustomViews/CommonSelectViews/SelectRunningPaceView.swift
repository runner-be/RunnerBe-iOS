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
            if !isCheckBox {
                [beginnerView, averageView, highView, masterView].forEach { view in
                    if view.isOn {
                        view.isOn = false
                    }
                }
                return
            }

            switch selected {
            case "all":
                if allView?.isOn ?? false {
                    [beginnerView, averageView, highView, masterView].forEach {
                        $0.isDisable = true
                    }
                    selectedPaces = ["beginner", "average", "high", "master"]
                } else {
                    [beginnerView, averageView, highView, masterView].forEach {
                        $0.isDisable = false
                    }
                    selectedPaces = []
                }

            case "beginner":
                if beginnerView.isOn {
                    selectedPaces.append("beginner")
                } else {
                    selectedPaces = selectedPaces.filter { $0 != "beginner" }
                }
            case "average":
                if averageView.isOn {
                    selectedPaces.append("average")
                } else {
                    selectedPaces = selectedPaces.filter { $0 != "average" }
                }
            case "high":
                if highView.isOn {
                    selectedPaces.append("high")
                } else {
                    selectedPaces = selectedPaces.filter { $0 != "high" }
                }
            case "master":
                if masterView.isOn {
                    selectedPaces.append("master")
                } else {
                    selectedPaces = selectedPaces.filter { $0 != "master" }
                }

            default:
                break
            }
        }
    }

    var selectedPaces: [String] = []

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
        label.numberOfLines = 0

        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12 + 8)
            $0.left.bottom.right.equalToSuperview().inset(12)
        }
        view.snp.makeConstraints {
            $0.width.equalTo(193)
            $0.height.equalTo(64)
        }

        view.isHidden = true
    }

    private var vStackView: UIStackView

    var allView: OnOffLabelButtonBase?
    var beginnerView: OnOffLabelButtonBase
    var averageView: OnOffLabelButtonBase
    var highView: OnOffLabelButtonBase
    var masterView: OnOffLabelButtonBase

    var isCheckBox: Bool

    init(isCheckBox: Bool = false) {
        self.isCheckBox = isCheckBox

        if isCheckBox {
            allView = OnOffLabelWithCheckBoxButton(
                iconSize: .zero,
                spacing: 0
            ).then { view in
                view.label.icon.image = nil
                view.label.label.text = "전체 선택"
            }

            beginnerView = OnOffLabelWithCheckBoxButton().then { view in
                view.label.icon.image = Asset.runningPaceBeginner.image
                view.label.label.text = L10n.RunningPace.Beginner.title
            }

            averageView = OnOffLabelWithCheckBoxButton().then { view in
                view.label.icon.image = Asset.runningPaceAverage.image
                view.label.label.text = L10n.RunningPace.Average.title
            }

            highView = OnOffLabelWithCheckBoxButton().then { view in
                view.label.icon.image = Asset.runningPaceHigh.image
                view.label.label.text = L10n.RunningPace.High.title
            }

            masterView = OnOffLabelWithCheckBoxButton().then { view in
                view.label.icon.image = Asset.runningPaceMaster.image
                view.label.label.text = L10n.RunningPace.Master.title
            }

            vStackView = UIStackView.make(
                with: [
                    allView ?? UIView(),
                    masterView,
                    highView,
                    averageView,
                    beginnerView,
                ],
                axis: .vertical,
                alignment: .fill,
                distribution: .equalSpacing,
                spacing: 32
            )
        } else {
            beginnerView = OnOffLabelWithRadioButton().then { view in
                view.label.icon.image = Asset.runningPaceBeginner.image
                view.label.label.text = L10n.RunningPace.Beginner.title
            }

            averageView = OnOffLabelWithRadioButton().then { view in
                view.label.icon.image = Asset.runningPaceAverage.image
                view.label.label.text = L10n.RunningPace.Average.title
            }

            highView = OnOffLabelWithRadioButton().then { view in
                view.label.icon.image = Asset.runningPaceHigh.image
                view.label.label.text = L10n.RunningPace.High.title
            }

            masterView = OnOffLabelWithRadioButton().then { view in
                view.label.icon.image = Asset.runningPaceMaster.image
                view.label.label.text = L10n.RunningPace.Master.title
            }
            vStackView = UIStackView.make(
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
        }
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
        bringSubviewToFront(titleLabel)

        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGlobalTap(_:)))
            tapGesture.cancelsTouchesInView = false
            window.addGestureRecognizer(tapGesture)
        }
    }

    @objc private func handleGlobalTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: contentView)
        let isTouchInfoLogo = infoLogo.frame.contains(location)

        if isTouchInfoLogo {
            infoWordBubble.isHidden.toggle()
        } else {
            infoWordBubble.isHidden = true
        }
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
