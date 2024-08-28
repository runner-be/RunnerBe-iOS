//
//  MyLogStampView.swift
//  Runner-be
//
//  Created by 김창규 on 8/26/24.
//

import UIKit

final class MyLogStampView: UIView {
    // MARK: - UI

    let pageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.numberOfPages = 3
        $0.pageIndicatorTintColor = .darkG45
        $0.currentPageIndicatorTintColor = .darkG2
    }

    private let dateLabel = UILabel().then {
        $0.text = "2024년 3월"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let titleIcon = UIImageView().then {
        $0.image = Asset.scheduled.uiImage
    }

    private let hStackView = UIStackView.make(
        with: ["월", "화", "수", "목", "금", "토", "일"].map { text in
            UILabel().then { label in
                label.font = .pretendardSemiBold16
                label.text = text
                label.textColor = .darkG45
                label.textAlignment = .center
            }
        },
        axis: .horizontal,
        alignment: .center,
        distribution: .fillEqually,
        spacing: 0
    )

    lazy var logStampCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        var collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            MyLogStampCell.self,
            forCellWithReuseIdentifier: MyLogStampCell.id
        )
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0)

        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let logCountView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .darkG6
    }

    private let logCountEmptyLabel = UILabel().then {
        $0.text = "이달의 스탬프를 채워봐요!"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension MyLogStampView {
    private func setupViews() {
        addSubviews([
            dateLabel,
            titleIcon,
            hStackView,
            logStampCollectionView,
            pageControl,
            logCountView,
        ])

        logCountView.addSubviews([
            logCountEmptyLabel,
        ])
    }

    private func initialLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(16)
        }

        titleIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.right.equalToSuperview().inset(16)
        }

        hStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(22)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }

        logStampCollectionView.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(56 + 16)
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(logStampCollectionView.snp.bottom).offset(14)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(6)
        }

        logCountView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
            $0.bottom.equalToSuperview().inset(8)
        }

        logCountEmptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
