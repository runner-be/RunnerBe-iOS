//
//  ReceivedStampListView.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

final class ReceivedStampListView: UIView {
    // MARK: - Properties

    // MARK: - UI

    private let titleLabel = UILabel().then {
        $0.text = " 님이 받은 스탬프"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    lazy var stampCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        var collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            ReceivedStampCell.self,
            forCellWithReuseIdentifier: ReceivedStampCell.id
        )

        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

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

    func update(stamp _: String) { // 임시
    }
}

// MARK: - Layout

extension ReceivedStampListView {
    private func setupViews() {
        addSubviews([
            titleLabel,
            stampCollectionView,
        ])
    }

    private func initialLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        stampCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(68)
        }
    }
}
