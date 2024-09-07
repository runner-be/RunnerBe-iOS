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

    // MARK: - Methods

    func updateCountLabel(with logTotalCount: LogTotalCount) {
        if logTotalCount.groupRunningCount == 0 &&
            logTotalCount.personalRunningCount == 0
        {
            logCountEmptyLabel.text = "이달의 스탬프를 채워봐요!"
            return
        }

        // 기본 텍스트 설정
        let groupText = "크루 \(logTotalCount.groupRunningCount)회"
        let personalText = "개인 \(logTotalCount.personalRunningCount)회"
        let fullText = "\(groupText) ㆍ \(personalText)"

        // NSMutableAttributedString으로 변환
        let attributedText = NSMutableAttributedString(string: fullText)

        // 숫자 부분의 범위 계산
        let groupCountRange = (fullText as NSString).range(of: "\(logTotalCount.groupRunningCount)회")
        let personalCountRange = (fullText as NSString).range(of: "\(logTotalCount.personalRunningCount)회")

        // 원하는 폰트와 색상 설정
        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendardSemiBold14,
            .foregroundColor: UIColor.darkG2,
        ]

        // 숫자 부분에 스타일 적용
        attributedText.addAttributes(highlightAttributes, range: groupCountRange)
        attributedText.addAttributes(highlightAttributes, range: personalCountRange)

        // 라벨에 적용
        logCountEmptyLabel.attributedText = attributedText
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
