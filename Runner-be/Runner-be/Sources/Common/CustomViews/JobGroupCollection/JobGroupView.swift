//
//  JobGroupView.swift
//  Runner-be
//
//  Created by 김신우 on 2022/09/12.
//

import SnapKit
import UIKit

class JobGroupView: UIView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var jobLabels = Job.allCases.reduce(into: [OnOffLabel]()) { partialResult, job in
        if job != .none {
            partialResult.append(OnOffLabel(text: job.emoji + " " + job.name))
        }
    }

    var jobGroup = OnOffLabelGroup().then { group in
        group.styleOn = OnOffLabel.Style(
            font: .iosBody15B,
            backgroundColor: .primary,
            textColor: .darkG6,
            borderWidth: 1,
            borderColor: .primary,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.styleOff = OnOffLabel.Style(
            font: .iosBody15B,
            backgroundColor: .clear,
            textColor: .darkG35,
            borderWidth: 1,
            borderColor: .darkG35,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.maxNumberOfOnState = 1
    }

    let xSpacing: CGFloat = 12
    private lazy var hStackViews = [
        UIStackView.make(
            with: jobLabels.enumerated().filter { $0.offset >= 0 && $0.offset < 3 }.map { $0.element },
            axis: .horizontal,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: xSpacing
        ),
        UIStackView.make(
            with: jobLabels.enumerated().filter { $0.offset >= 3 && $0.offset < 5 }.map { $0.element },
            axis: .horizontal,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: xSpacing
        ),
        UIStackView.make(
            with: jobLabels.enumerated().filter { $0.offset >= 5 && $0.offset < 8 }.map { $0.element },
            axis: .horizontal,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: xSpacing
        ),
        UIStackView.make(
            with: jobLabels.enumerated().filter { $0.offset >= 8 && $0.offset < 11 }.map { $0.element },
            axis: .horizontal,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: xSpacing
        ),
        UIStackView.make(
            with: jobLabels.enumerated().filter { $0.offset >= 11 && $0.offset < 14 }.map { $0.element },
            axis: .horizontal,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: xSpacing
        ),
    ]

    private lazy var vStackView = UIStackView.make(
        with: hStackViews,
        axis: .vertical,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 24
    )

    func setupViews() {
        addSubviews([
            vStackView,
        ])

        jobGroup.append(labels: jobLabels)
    }

    func initialLayout() {
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
