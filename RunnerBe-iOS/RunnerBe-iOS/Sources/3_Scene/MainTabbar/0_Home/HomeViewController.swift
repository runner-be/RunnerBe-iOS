//
//  HomeViewController.swift
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
import Toast_Swift
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
            .bind(to: viewModel.inputs.showDetailFilter)
            .disposed(by: disposeBags)

        floatingButton.rx.tap
            .bind(to: viewModel.inputs.writingPost)
            .disposed(by: disposeBags)

        deadlineFilter.tapCheck
            .bind(to: viewModel.inputs.deadLineChanged)
            .disposed(by: disposeBags)

        postCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        typealias BasicPostSectionDataSource
            = RxCollectionViewSectionedAnimatedDataSource<BasicPostSection>

        let dataSource = BasicPostSectionDataSource { [weak self] _, collectionView, indexPath, item in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicPostCell.id, for: indexPath) as? BasicPostCell
            else { return UICollectionViewCell() }

            self.viewModel.outputs.bookMarked
                .filter { $0.idx == indexPath.row }
                .map { $0.marked }
                .subscribe(onNext: { [weak cell] marked in
                    cell?.postInfoView.bookMarkIcon.isSelected = marked
                })
                .disposed(by: cell.disposeBag)

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
            .map {
                $0.reduce(into: [PostCellConfig]()) {
                    $0.append(PostCellConfig(from: $1))
                }
            }
            .map { [BasicPostSection(items: $0)] }
            .bind(to: postCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBags)

        viewModel.outputs.highLightFilter
            .subscribe(onNext: { [weak self] highlight in
                self?.filterIcon.image = highlight ? Asset.filterHighlighted.uiImage : Asset.filter.uiImage
            })
            .disposed(by: disposeBags)

        viewModel.outputs.refresh
            .subscribe(onNext: { [weak self] in
                self?.postCollectionView.collectionViewLayout.invalidateLayout()
                self?.postCollectionView.bounds.origin = CGPoint(x: 0, y: 0)
            })
            .disposed(by: disposeBags)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBags)
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

    var deadlineFilter = CheckBoxView().then { view in
        view.leftBox = false
        view.labelText = L10n.Home.PostList.Filter.CheckBox.includeClosedPost
        view.moreInfoButton.isHidden = true
        view.checkBoxButton.tintColor = .darkG35
        view.titleLabel.textColor = .darkG4
        view.titleLabel.font = .iosBody13R
        view.spacing = 5
        view.isSelected = false
    }

    private var orderFilter = IconLabel(iconPosition: .right, iconSize: CGSize(width: 16, height: 16), spacing: 4).then { view in
        view.icon.image = Asset.chevronDown.uiImage
        view.label.font = .iosBody13R
        view.label.textColor = .darkG4
        view.label.text = L10n.Home.PostList.Filter.Order.distance
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
        collectionView.register(BasicPostCell.self, forCellWithReuseIdentifier: BasicPostCell.id)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-28)
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

extension HomeViewController: SegmentedControlDelegate {
    func didChanged(_: SegmentedControl, from: Int, to: Int) {
        if from != to {
            viewModel.inputs.tagChanged.onNext(to)
        }
    }
}
