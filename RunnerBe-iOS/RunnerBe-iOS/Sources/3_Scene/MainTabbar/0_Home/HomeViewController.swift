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

    private func viewModelInput() {
        filterIcon.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.filter)
            .disposed(by: disposeBags)

        // TODO: 플로팅 버튼 생성후 거기에 연결
        floatingButton.rx.tap
            .bind(to: viewModel.inputs.writingPost)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        // 서버 연결
        viewModel.outputs.posts
            .bind(to: postCollectionView.rx.items(cellIdentifier: BasicPostCellView.id, cellType: BasicPostCellView.self)) { _, post, cell in
                let configuration = PostCellConfiguringItem(from: post)
                cell.configure(with: configuration)
            }
            .disposed(by: disposeBags)
    }

    private var segmentedControl = SegmentedControl().then { control in
        control.defaultTextFont = .iosBody15R
        control.defaultTextColor = .darkG45
        control.highlightTextFont = .iosBody15B
        control.highlightTextColor = .darkG5
        control.fontSize = 15
        control.boxColors = [.darkG6]
        control.highlightBoxColors = [.segmentBgTop, .segmentBgBot]
        control.highlightBoxPadding = .zero
        control.boxPadding = UIEdgeInsets(top: 6, left: 0, bottom: 8, right: 0)

        control.items = [
            L10n.Post.WorkTime.afterWork,
            L10n.Post.WorkTime.beforeWork,
            L10n.Post.WorkTime.dayOff,
        ]
    }

    private var deadlineFilter = IconLabel(iconPosition: .right).then { view in
        view.icon.image = Asset.checkBoxIconEmpty.uiImage
        view.label.font = .iosBody13R
        view.label.textColor = .darkG4
        view.label.text = L10n.Home.PostList.Filter.CheckBox.includeClosedPost
        view.iconSize = CGSize(width: 24, height: 24)
        view.spacing = 5
    }

    private var orderFilter = IconLabel(iconPosition: .right).then { view in
        view.icon.image = Asset.chevronDown.uiImage
        view.label.font = .iosBody13R
        view.label.textColor = .darkG4
        view.label.text = L10n.Home.PostList.Filter.Order.distance
        view.iconSize = CGSize(width: 16, height: 16)
        view.spacing = 4
    }

    private var filterIcon = UIImageView().then { view in
        view.image = Asset.filter.uiImage
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .aggroLight
        navBar.titleLabel.text = L10n.Home.PostList.NavBar.title
        navBar.titleLabel.textColor = .primarydark
        navBar.rightBtnItem.setImage(Asset.search.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 8
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

    private var floatingButton = UIButton().then { button in
        button.setImage(Asset.floatingButton.uiImage, for: .normal)
    }
}

// MARK: - Layout

extension HomeViewController {
    private func setupViews() {
        gradientBackground()
        view.addSubviews([
            navBar,
            segmentedControl,
            deadlineFilter,
            orderFilter,
            filterIcon,
            postCollectionView,
            floatingButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
        }

        filterIcon.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        orderFilter.snp.makeConstraints { make in
            make.centerY.equalTo(filterIcon.snp.centerY)
            make.trailing.equalTo(filterIcon.snp.leading).offset(-16)
        }

        deadlineFilter.snp.makeConstraints { make in
            make.centerY.equalTo(filterIcon.snp.centerY)
            make.trailing.equalTo(orderFilter.snp.leading).offset(-29)
        }

        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterIcon.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }

        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
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
