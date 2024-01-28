//
//  SelectJobView.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/17.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class SelectJobView: SelectBaseView {
    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var jobGroup: OnOffLabelGroup {
        jobGroupView.jobGroup
    }

    func select(idx: Int) {
        reset()

        if idx >= 0, idx < jobGroupView.jobLabels.count {
            jobGroupView.jobGroup.toggle(label: jobGroupView.jobLabels[idx])
        }
    }

    func reset() {
        jobGroupView.jobLabels.forEach {
            if $0.isOn {
                self.jobGroupView.jobGroup.toggle(label: $0)
            }
        }
    }

    var jobGroupView = JobGroupView()

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Job.title

        contentView.addSubviews([
            jobGroupView,
        ])
    }

    override func initialLayout() {
        super.initialLayout()

        jobGroupView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
