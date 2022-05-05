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
        configureCollectionViewItems()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(idx: Int) {
        reset()

        if idx >= 0, idx < jobLabels.count {
            jobGroup.toggle(label: jobLabels[idx])
        }
    }

    func reset() {
        jobLabels.forEach {
            if $0.isOn {
                self.jobGroup.toggle(label: $0)
            }
        }
    }

    private func configureCollectionViewItems() {
        // TODO: 직군 종류들을 ViewModel로 넘길지 고민해보기
        let jobGroupLabels = Observable.of(jobLabels)
        jobGroupLabels.bind(
            to: jobGroupCollectionView.rx.items(
                cellIdentifier: JobGroupCollectionViewCell.id,
                cellType: JobGroupCollectionViewCell.self
            )
        ) { _, label, cell in cell.label = label }
            .disposed(by: disposeBag)
    }

    private var jobLabels = Job.allCases.reduce(into: [OnOffLabel]()) { partialResult, job in
        if job != .none {
            partialResult.append(OnOffLabel(text: job.name))
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
            font: .iosBody15R,
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

    var jobGroupCollectionView: UICollectionView = {
        var layout = JobGroupCollectionViewLayout()
        layout.xSpacing = 12
        layout.ySpacing = 16
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(JobGroupCollectionViewCell.self, forCellWithReuseIdentifier: JobGroupCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func setupViews() {
        super.setupViews()
        titleLabel.text = L10n.Home.Filter.Job.title

        contentView.addSubviews([
            jobGroupCollectionView,
        ])

        jobGroup.append(labels: jobLabels)
    }

    override func initialLayout() {
        super.initialLayout()

        jobGroupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(38)
            make.trailing.equalTo(contentView.snp.trailing).offset(-38)
            make.height.equalTo(244)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize

        let collectionViewSize = jobGroupCollectionView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: size.height + collectionViewSize.height
        )
    }
}