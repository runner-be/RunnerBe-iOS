//
//  BookMarkViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BookMarkViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: BookMarkViewModel) {
        self.viewModel = viewModel
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: BookMarkViewModel

    private func viewModelInput() {
        postCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<BasicPostSection> {
            [weak self] _, collectionView, indexPath, item in

                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicPostCellView.id, for: indexPath) as? BasicPostCellView
                else { return UICollectionViewCell() }

                cell.postInfoView.bookMarkIcon.rx.tap
                    .map { indexPath.row }
                    .subscribe(onNext: { [weak self] idx in
                        self?.viewModel.inputs.tapPostBookMark.onNext(idx)
                    })
                    .disposed(by: cell.disposeBag)

                cell.configure(with: item)
                return cell
        }

        viewModel.outputs.posts
            .do(onNext: { [weak self] configs in
                self?.numPostLabel.text = "총 \(configs.count) 건"
            })
            .map { [BasicPostSection(items: $0)] }
            .bind(to: postCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBags)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .aggroLight
        navBar.titleLabel.text = L10n.BookMark.Main.NavBar.title
        navBar.titleLabel.textColor = .primarydark
        navBar.rightBtnItem.setImage(Asset.search.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 8
    }

    private lazy var segmentedControl = SegmentedControl().then { control in
        control.defaultTextFont = .iosBody15R
        control.defaultTextColor = .darkG45
        control.highlightTextFont = .iosBody15B
        control.highlightTextColor = .darkG5
        control.fontSize = 15
        control.boxColors = [.darkG6]
        control.highlightBoxColors = [.segmentBgTop, .segmentBgBot]
        control.highlightBoxPadding = .zero
        control.boxPadding = UIEdgeInsets(top: 6, left: 0, bottom: 8, right: 0)

        control.items = RunningTag.allCases.reduce(into: [String]()) {
            if !$1.name.isEmpty {
                $0.append($1.name)
            }
        }

        control.delegate = self
    }

    var numPostLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .darkG4
        label.text = "총 n 건"
    }

    private lazy var postCollectionView: UICollectionView = {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(143)
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

extension BookMarkViewController {
    private func setupViews() {
        gradientBackground()
        view.addSubviews([
            navBar,
            segmentedControl,
            numPostLabel,
            postCollectionView,
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

        numPostLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(14)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(numPostLabel.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(14)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
    }

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.bookmarkTabIconNormal.uiImage,
            selectedImage: Asset.bookmarkTabIconFocused.uiImage
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

extension BookMarkViewController: SegmentedControlDelegate {
    func didChanged(_: SegmentedControl, from: Int, to: Int) {
        if from != to {
            viewModel.inputs.tagChanged.onNext(to)
        }
    }
}
