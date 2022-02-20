//
//  HomeViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: HomeViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {
        let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
        let itemsOb = Observable.of(items)
        itemsOb.bind(to: postCollectionView.rx.items(cellIdentifier: BasicPostCellView.id, cellType: BasicPostCellView.self)) { row, _, cell in
            let alpha = CGFloat(row) / 10
            cell.blurAlpha = alpha
            cell.postState = .closed
        }
        .disposed(by: disposeBags)
    }

    private lazy var postCollectionView: UICollectionView = {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )
        var item = NSCollectionLayoutItem(layoutSize: size)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(12),
            trailing: .fixed(0),
            bottom: .fixed(12)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BasicPostCellView.self, forCellWithReuseIdentifier: BasicPostCellView.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
}

// MARK: - Layout

extension HomeViewController {
    private func setupViews() {
        gradientBackground()
        view.addSubviews([
            postCollectionView,
        ])
    }

    private func initialLayout() {
        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-14)
        }
    }

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.homeTabIconNormal.uiImage,
            selectedImage: Asset.homeTabIconFocused.uiImage
        )
        tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
    }

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.bgBottom.cgColor,
            UIColor.bgTop.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
