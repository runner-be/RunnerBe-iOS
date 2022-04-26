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

class HomeViewController: RunnerbeBaseViewController {
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
            .disposed(by: disposeBag)

        floatingButton.rx.tap
            .bind(to: viewModel.inputs.writingPost)
            .disposed(by: disposeBag)

        deadlineFilter.tapCheck
            .bind(to: viewModel.inputs.deadLineChanged)
            .disposed(by: disposeBag)

        postCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        postCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

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
            .disposed(by: disposeBag)

        viewModel.outputs.posts
            .map { !$0.isEmpty }
            .subscribe(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.outputs.highLightFilter
            .subscribe(onNext: { [weak self] highlight in
                self?.filterIcon.image = highlight ? Asset.filterHighlighted.uiImage : Asset.filter.uiImage
            })
            .disposed(by: disposeBag)

        viewModel.outputs.refresh
            .subscribe(onNext: { [weak self] in
                self?.postCollectionView.collectionViewLayout.invalidateLayout()
                self?.postCollectionView.bounds.origin = CGPoint(x: 0, y: 0)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBag)
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
        view.isHidden = true
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
        navBar.rightBtnItem.isHidden = true
        navBar.titleSpacing = 8
    }

    private lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BasicPostCell.self, forCellWithReuseIdentifier: BasicPostCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var emptyLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG45
        label.text = L10n.Home.PostList.Empty.title
        label.isHidden = true
    }

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
//            orderFilter,
            filterIcon,
            postCollectionView,
            floatingButton,
            emptyLabel,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
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

//        orderFilter.snp.makeConstraints { make in
//            make.centerY.equalTo(filterIcon.snp.centerY)
//            make.trailing.equalTo(filterIcon.snp.leading).offset(-16)
//        }

        deadlineFilter.snp.makeConstraints { make in
            make.centerY.equalTo(filterIcon.snp.centerY)
            make.trailing.equalTo(filterIcon.snp.leading).offset(-10)
        }

        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterIcon.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }

        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-28)
            make.trailing.equalTo(view.snp.trailing).offset(-14)
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(postCollectionView.snp.center)
        }
    }
}

extension HomeViewController: SegmentedControlDelegate {
    func didChanged(_: SegmentedControl, from: Int, to: Int) {
        if from != to {
            viewModel.inputs.tagChanged.onNext(to)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return BasicPostCell.size
    }
}
