//
//  SelectPlaceResultsView.swift
//  Runner-be
//
//  Created by 김창규 on 8/21/24.
//

import UIKit

final class SelectPlaceResultsView: UIView {
    // MARK: - UI

    lazy var resultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        var collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            SelectPlaceResultCell.self,
            forCellWithReuseIdentifier: SelectPlaceResultCell.id
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
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
}

// MARK: - Layout

extension SelectPlaceResultsView {
    private func setupViews() {
        addSubviews([
            resultCollectionView,
        ])
    }

    private func initialLayout() {
        resultCollectionView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension SelectPlaceResultsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return SelectPlaceResultCell.size
    }
}
