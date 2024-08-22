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

import MapKit

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
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: HomeViewModel

    private func viewModelInput() {
        bindBottomSheetGesture()

        showClosedPostView.rx.tapGesture(configuration: nil)
            .map { _ in }
            .bind(to: viewModel.inputs.tapShowClosedPost)
            .disposed(by: disposeBag)

        postCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBag)

        postCollectionView.rx.contentOffset
            .flatMap { [weak self] offset -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                let visibleHeight = self.postCollectionView.frame.height - self.postCollectionView.contentInset.top - self.postCollectionView.contentInset.bottom
                let y = offset.y + self.postCollectionView.contentInset.top
                let threshold = max(0.0, self.postCollectionView.contentSize.height - visibleHeight - (BasicPostCell.size.height))
                return y > threshold ? Observable.just(()) : Observable.empty()
            }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.loadNextPagePosts.onNext(true)
            })
            .disposed(by: disposeBag)

        selectedPostCollectionView.rx.itemSelected
            .map { _ in }
            .bind(to: viewModel.inputs.tapSelectedPost)
            .disposed(by: disposeBag)

        mapView.postSelected
            .bind(to: viewModel.inputs.tapPostPin)
            .disposed(by: disposeBag)

        mapView.regionWillChange
            .bind(to: viewModel.inputs.moveRegion)
            .disposed(by: disposeBag)

        mapView.regionChanged
            .bind(to: viewModel.inputs.regionChanged)
            .disposed(by: disposeBag)

        homeLocationButton.rx.tapGesture(configuration: nil)
            .map { _ in }
            .bind(to: viewModel.inputs.toHomeLocation)
            .disposed(by: disposeBag)

        refreshPostListButton.rx.tapGesture(configuration: nil)
            .skip(1) // 첫 번째 이벤트를 건너뛰기
            .map { _ in true }
            .do(onNext: { [weak self] _ in
                self?.postCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            })
            .bind(to: viewModel.inputs.needUpdate)
            .disposed(by: disposeBag)

        writePostButton.rx.tapGesture(configuration: nil)
            .map { _ in }
            .bind(to: viewModel.inputs.writingPost)
            .disposed(by: disposeBag)

        filterIconView.rx.tapGesture(configuration: nil)
            .map { _ in }
            .bind(to: viewModel.inputs.showDetailFilter)
            .disposed(by: disposeBag)

        orderTagView.rx.tapGesture(configuration: nil)
            .map { _ in }
            .bind(to: viewModel.inputs.tapPostListOrder)
            .disposed(by: disposeBag)

        runningTagView.rx.tapGesture(configuration: nil)
            .map { _ in }
            .bind(to: viewModel.inputs.tapRunningTag)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapAlarm)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        postCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        selectedPostCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        typealias PostSectionDataSource = RxCollectionViewSectionedReloadDataSource<BasicPostSection>

        viewModel.outputs.posts
            .map {
                $0.reduce(into: [PostCellConfig]()) {
                    $0.append(PostCellConfig(from: $1))
                }
            }
            .map { [BasicPostSection(items: $0)] }
            .bind(to: postCollectionView.rx.items(dataSource: PostSectionDataSource { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                return self.configureCell(collectionView, indexPath, item)
            }))
            .disposed(by: disposeBag)

        viewModel.outputs.showClosedPost
            .subscribe(onNext: { [weak self] show in
                self?.showClosedPost(show)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.posts
            .subscribe(onNext: { [unowned self] posts in
                self.mapView.update(with: posts)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.posts
            .map { $0.count }
            .subscribe(onNext: { [unowned self] count in
                let hideEmptyGuide = count != 0
                self.postEmptyGuideLabel.isHidden = hideEmptyGuide
                self.adviseWritingPostView.isHidden = hideEmptyGuide
            })
            .disposed(by: disposeBag)

        viewModel.outputs.changeRegion
            .subscribe(onNext: { [weak self] region in
                self?.mapView.setRegion(to: region.location, radius: region.distance)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.showRefreshRegion
            .map { !$0 }
            .subscribe(onNext: { [weak self] hidden in
                self?.refreshPostListButton.isHidden = hidden
            })
            .disposed(by: disposeBag)

        viewModel.outputs.focusSelectedPost
            .map {
                if let post = $0 {
                    return [PostCellConfig(from: post)]
                } else {
                    return []
                }
            }
            .map { [BasicPostSection(items: $0)] }
            .bind(to: selectedPostCollectionView.rx.items(dataSource: PostSectionDataSource { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                return self.configureCell(collectionView, indexPath, item)
            }))
            .disposed(by: disposeBag)

        viewModel.outputs.focusSelectedPost
            .subscribe(onNext: { [unowned self] post in
                let hideSelectedPost = (post == nil)
                self.postCollectionView.isHidden = !hideSelectedPost
                self.selectedPostCollectionView.isHidden = hideSelectedPost

                if post != nil {
                    self.mapView.isAnnotationHidden = true
                    self.setBottomSheetState(to: .halfOpen, animated: true) { [weak self] in
                        self?.mapView.isAnnotationHidden = false
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.postListOrderChanged
            .subscribe(onNext: { [unowned self] listOrder in
                self.orderTagView.label.text = listOrder.text
            })
            .disposed(by: disposeBag)

        viewModel.outputs.runningTagChanged
            .subscribe(onNext: { [unowned self] tag in
                self.runningTagView.label.text = tag.name
            })
            .disposed(by: disposeBag)

        viewModel.outputs.titleLocationChanged
            .subscribe(onNext: { [unowned self] title in
                if let title = title {
                    navBar.titleLabel.font = .iosBody17R
                    navBar.titleLabel.text = title
                    navBar.titleLabel.textColor = .darkG35
                    navBar.titleSpacing = 12
                } else {
                    navBar.titleLabel.font = .aggroLight
                    navBar.titleLabel.text = L10n.Home.PostList.NavBar.title
                    navBar.titleLabel.textColor = .primarydark
                    navBar.titleSpacing = 8
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.alarmChecked
            .subscribe(onNext: { [weak self] isChecked in
                self?.navBar.rightBtnItem.setImage(isChecked ? Asset.alarmNomal.uiImage : Asset.alarmNew.uiImage, for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private func bindBottomSheetGesture() {
        bottomSheet.rx.panGesture()
            .when(.changed)
            .filter { [unowned self] gesture in
                let location = gesture.location(in: self.bottomSheet)
                return isBottomSheetPanGestureEnable(with: location)
            }
            .asTranslation()
            .subscribe(onNext: { [unowned self] translation, _ in
                self.onPanGesture(translation: translation)
            })
            .disposed(by: disposeBag)

        bottomSheet.rx.panGesture()
            .when(.ended)
            .asTranslation()
            .subscribe(onNext: { [unowned self] _, _ in
                onPanGestureEnded()
            })
            .disposed(by: disposeBag)
    }

    private func showClosedPost(_ show: Bool) {
        if show {
            showClosedPostView.label.font = Constants.BottomSheet.SelectionLabel.HighLighted.font
            showClosedPostView.label.textColor = Constants.BottomSheet.SelectionLabel.HighLighted.textColor
            showClosedPostView.backgroundColor = Constants.BottomSheet.SelectionLabel.HighLighted.backgroundColor
            showClosedPostView.layer.borderWidth = Constants.BottomSheet.SelectionLabel.HighLighted.borderWidth
            showClosedPostView.layer.borderColor = Constants.BottomSheet.SelectionLabel.HighLighted.borderColor
        } else {
            showClosedPostView.label.font = Constants.BottomSheet.SelectionLabel.Normal.font
            showClosedPostView.label.textColor = Constants.BottomSheet.SelectionLabel.Normal.textColor
            showClosedPostView.backgroundColor = Constants.BottomSheet.SelectionLabel.Normal.backgroundColor
            showClosedPostView.layer.borderWidth = Constants.BottomSheet.SelectionLabel.Normal.borderWidth
            showClosedPostView.layer.borderColor = Constants.BottomSheet.SelectionLabel.Normal.borderColor
        }
    }

    private func configureCell(
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ item: BasicPostSection.Item
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicPostCell.id, for: indexPath) as? BasicPostCell
        else { return UICollectionViewCell() }

        viewModel.outputs.bookMarked
            .filter { $0.id == item.id }
            .map { $0.marked }
            .subscribe(onNext: { [weak cell] marked in
                cell?.postInfoView.bookMarkIcon.isSelected = marked
            })
            .disposed(by: cell.disposeBag)

        cell.postInfoView.bookMarkIcon.rx.tap
            .map { item.id }
            .subscribe(onNext: { [weak self] id in
                self?.viewModel.inputs.tapPostBookmark.onNext(id)
            })
            .disposed(by: cell.disposeBag)

        cell.configure(with: item)
        return cell
    }

    enum Constants {
        enum NavigationBar {
            static let backgroundColor: UIColor = .darkG7
        }

        enum RefreshButton {
            static let topSpacing: CGFloat = 16

            static let iconSize: CGFloat = 20
            static let text: String = L10n.Home.Map.RefreshButton.title
            static let paddingLeft: CGFloat = 10
            static let paddingRight: CGFloat = 14
            static let spacing: CGFloat = 4
            static let height: CGFloat = 36
        }

        enum HomeLocationButton {
            static let width: CGFloat = 40
            static let height: CGFloat = 40
            static let leading: CGFloat = 12
            static let bottom: CGFloat = 12
            static let bottomLimit: CGFloat = Constants.BottomSheet.heightMiddle + Constants.HomeLocationButton.bottom
        }

        enum BottomSheet {
            static let backgrouncColor: UIColor = .darkG7
            static let cornerRadius: CGFloat = 12
            static let heightMiddle: CGFloat = 294
            static let heightMin: CGFloat = 65

            enum GreyHandle {
                static let top: CGFloat = 16
                static let width: CGFloat = 37
                static let height: CGFloat = 3
                static let color: UIColor = .darkG6
            }

            enum Title {
                static let leading: CGFloat = 16
                static let top: CGFloat = 24
                static let height: CGFloat = 29
                static let color: UIColor = .darkG25
                static let font: UIFont = .iosTitle21Sb
                static let text: String = L10n.Home.BottomSheet.title
            }

            enum SelectionLabel {
                static let iconSize: CGSize = .init(width: 16, height: 16)
                static let height: CGFloat = 36
                static let cornerRadius: CGFloat = height / 2.0
                static let padding: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)

                enum HighLighted {
                    static let font: UIFont = .pretendardBold14
                    static let backgroundColor: UIColor = .primarydark
                    static let textColor: UIColor = .darkBlack
                    static let borderWidth: CGFloat = 0
                    static let borderColor: CGColor = UIColor.primarydark.cgColor
                    static let icon: UIImage = Asset.chevronDownNew.uiImage.withTintColor(.darkG4)
                }

                enum Normal {
                    static let font: UIFont = .pretendardRegular14
                    static let backgroundColor: UIColor = .clear
                    static let textColor: UIColor = .darkG4
                    static let borderWidth: CGFloat = 1
                    static let borderColor: CGColor = UIColor.darkG4.cgColor
                    static let icon: UIImage = Asset.chevronDown.uiImage.withTintColor(.darkG4)
                }

                enum RunningTag {
                    static let leading: CGFloat = 8
                    static let top: CGFloat = Title.top + Title.height + 23
                }

                enum OrderTag {
                    static let leading: CGFloat = 8
                }

                enum ShowClosedPost {
                    static let leading: CGFloat = 8
                    static let padding: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
                }
            }

            enum PostList {
                static let top: CGFloat = Title.top + Title.height + 70
                static let minimumLineSpacing: CGFloat = 12
            }
        }
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .aggroLight
        navBar.titleLabel.text = L10n.Home.PostList.NavBar.title
        navBar.titleLabel.textColor = .primarydark
        navBar.rightBtnItem.setImage(Asset.alarmNew.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 8
        navBar.backgroundColor = Constants.NavigationBar.backgroundColor
    }

    private var mapView = RunnerBeMapView().then { mapView in
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false

        mapView.userTrackingMode = .none
    }

    private var refreshPostListButton = UIView().then { view in
        let imageView = UIImageView()
        imageView.image = Asset.refresh.uiImage.withTintColor(.darkG3)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        let label = UILabel()
        label.text = Constants.RefreshButton.text
        label.font = .iosBody15R
        label.textColor = .darkG3

        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.RefreshButton.height / 2
        view.backgroundColor = .darkG7

        view.addSubviews([imageView, label])
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(Constants.RefreshButton.paddingLeft)
        }
        label.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(imageView.snp.trailing).offset(Constants.RefreshButton.spacing)
            make.trailing.equalTo(view.snp.trailing).offset(-Constants.RefreshButton.paddingRight)
        }
        view.isHidden = true
    }

    private var homeLocationButton = UIImageView().then { view in
        view.image = Asset.homeLocation.uiImage
        view.snp.makeConstraints { make in
            make.width.equalTo(Constants.HomeLocationButton.width)
            make.height.equalTo(Constants.HomeLocationButton.height)
        }
    }

    private var bottomSheet = UIView().then { view in
        view.backgroundColor = Constants.BottomSheet.backgrouncColor
        view.layer.cornerRadius = Constants.BottomSheet.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
    }

    // view.bottom 과 bottomSheet.top 이므로 constant를 음수로 설정해야 함
    private lazy var bottomSheetHeight = bottomSheet.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constants.BottomSheet.heightMiddle)
    var bottomSheetPanGestureOffsetH: CGFloat = 0

    private var greyHandle = UIView().then { view in
        view.backgroundColor = Constants.BottomSheet.GreyHandle.color
    }

    private var sheetTitle = UILabel().then { label in
        label.textColor = Constants.BottomSheet.Title.color
        label.text = Constants.BottomSheet.Title.text
        label.font = Constants.BottomSheet.Title.font
    }

    private var runningTagView = SelectionLabel(spacing: 4).then { view in
        view.padding = Constants.BottomSheet.SelectionLabel.padding
        view.iconSize = Constants.BottomSheet.SelectionLabel.iconSize
        view.layer.cornerRadius = Constants.BottomSheet.SelectionLabel.cornerRadius

        view.label.font = .pretendardSemiBold14
        view.label.textColor = .darkG2
        view.backgroundColor = .darkG55
        view.icon.image = Constants.BottomSheet.SelectionLabel.HighLighted.icon

        view.label.text = "전체"
    }

    private var orderTagView = SelectionLabel(spacing: 4).then {
        $0.padding = Constants.BottomSheet.SelectionLabel.padding
        $0.iconSize = Constants.BottomSheet.SelectionLabel.iconSize
        $0.layer.cornerRadius = Constants.BottomSheet.SelectionLabel.cornerRadius

        $0.label.font = .pretendardSemiBold14
        $0.label.textColor = .darkG2
        $0.backgroundColor = .darkG55
        $0.icon.image = Constants.BottomSheet.SelectionLabel.HighLighted.icon

        $0.label.text = PostListOrder.distance.text
    }

    private var showClosedPostView = SelectionLabel().then { view in

        view.padding = Constants.BottomSheet.SelectionLabel.ShowClosedPost.padding
        view.layer.cornerRadius = Constants.BottomSheet.SelectionLabel.cornerRadius

        view.label.font = Constants.BottomSheet.SelectionLabel.Normal.font
        view.label.textColor = Constants.BottomSheet.SelectionLabel.Normal.textColor
        view.backgroundColor = Constants.BottomSheet.SelectionLabel.Normal.backgroundColor
        view.layer.borderWidth = Constants.BottomSheet.SelectionLabel.Normal.borderWidth
        view.layer.borderColor = Constants.BottomSheet.SelectionLabel.Normal.borderColor

        view.label.text = "마감 포함"
    }

    private var filterIconView = IconLabel(
        iconSize: CGSize(width: 18, height: 18),
        spacing: 4,
        padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    ).then {
        $0.label.font = .pretendardSemiBold14
        $0.label.textColor = .darkG2
        $0.label.text = "필터"
        $0.backgroundColor = .darkG55
        $0.layer.cornerRadius = 18
        $0.icon.image = Asset.filterActive.uiImage
        $0.icon.image?.withTintColor(.primary)
    }

    private lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.BottomSheet.PostList.minimumLineSpacing
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BasicPostCell.self, forCellWithReuseIdentifier: BasicPostCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var selectedPostCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.BottomSheet.PostList.minimumLineSpacing
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BasicPostCell.self, forCellWithReuseIdentifier: BasicPostCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        return collectionView
    }()

    private var postEmptyGuideLabel = UILabel().then { label in
        label.text = "조건에 맞는 결과가 없어요"
        label.textColor = .darkG4
        label.font = .iosTitle19R
    }

    private var adviseWritingPostView = UIImageView().then { view in
        view.image = Asset.postEmptyGuideBackground.uiImage
        view.snp.makeConstraints { make in
            make.width.equalTo(136)
            make.height.equalTo(28)
        }
        let label = UILabel()
        label.text = "첫 주자가 되어볼까요?"
        label.textColor = .primary
        label.font = .iosBody13R
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(9)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
        }
    }

    private var writePostButton = UIImageView().then { view in
        view.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(72)
        }
        view.image = Asset.floatingButton.uiImage
    }
}

// MARK: - Layout

extension HomeViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            mapView,
            refreshPostListButton,
            homeLocationButton,
            bottomSheet,
            writePostButton,
            adviseWritingPostView,
        ])

        bottomSheet.addSubviews([
            greyHandle,
            sheetTitle,

            filterIconView,
            orderTagView,
            runningTagView,

            showClosedPostView,
            postCollectionView,
            selectedPostCollectionView,
            postEmptyGuideLabel,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.greaterThanOrEqualTo(
                UIScreen.main.bounds.height - AppContext.shared.safeAreaInsets.top - AppContext.shared.safeAreaInsets.bottom
                    - AppContext.shared.navHeight - AppContext.shared.tabHeight - Constants.BottomSheet.heightMiddle
                    + Constants.BottomSheet.cornerRadius).priority(1000)
            make.bottom.equalTo(bottomSheet.snp.top).offset(Constants.BottomSheet.cornerRadius).priority(999)
        }

        refreshPostListButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.RefreshButton.height)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(navBar.snp.bottom).offset(Constants.RefreshButton.topSpacing)
        }

        homeLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(Constants.HomeLocationButton.leading)
            make.bottom.equalTo(bottomSheet.snp.top).offset(-12).priority(999)
            make.bottom.greaterThanOrEqualTo(view.snp.bottom).offset(-Constants.HomeLocationButton.bottomLimit).priority(1000)
        }

        bottomSheet.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(UIScreen.main.bounds.height - AppContext.shared.safeAreaInsets.bottom - AppContext.shared.safeAreaInsets.top - AppContext.shared.tabHeight)
        }
        bottomSheetHeight.isActive = true

        greyHandle.snp.makeConstraints { make in
            make.top.equalTo(bottomSheet.snp.top).offset(Constants.BottomSheet.GreyHandle.top)
            make.centerX.equalTo(bottomSheet.snp.centerX)
            make.height.equalTo(Constants.BottomSheet.GreyHandle.height)
            make.width.equalTo(Constants.BottomSheet.GreyHandle.width)
        }

        sheetTitle.snp.makeConstraints { make in
            make.top.equalTo(bottomSheet.snp.top).offset(Constants.BottomSheet.Title.top)
            make.leading.equalTo(bottomSheet.snp.leading).offset(Constants.BottomSheet.Title.leading)
            make.height.equalTo(Constants.BottomSheet.Title.height)
        }

        filterIconView.snp.makeConstraints { make in
            make.top.equalTo(sheetTitle.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(Constants.BottomSheet.SelectionLabel.height)
        }

        orderTagView.snp.makeConstraints { make in
            make.top.equalTo(filterIconView)
            make.leading.equalTo(filterIconView.snp.trailing).offset(Constants.BottomSheet.SelectionLabel.OrderTag.leading)
            make.height.equalTo(Constants.BottomSheet.SelectionLabel.height)
        }

        runningTagView.snp.makeConstraints { make in
            make.top.equalTo(filterIconView)
            make.leading.equalTo(orderTagView.snp.trailing).offset(Constants.BottomSheet.SelectionLabel.RunningTag.leading)
            make.height.equalTo(Constants.BottomSheet.SelectionLabel.height)
        }

        showClosedPostView.snp.makeConstraints { make in
            make.top.equalTo(filterIconView)
            make.leading.equalTo(runningTagView.snp.trailing).offset(Constants.BottomSheet.SelectionLabel.ShowClosedPost.leading)
            make.height.equalTo(Constants.BottomSheet.SelectionLabel.height)
        }

        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(bottomSheet.snp.top).offset(Constants.BottomSheet.PostList.top)
            make.leading.equalTo(bottomSheet.snp.leading)
            make.trailing.equalTo(bottomSheet.snp.trailing)
            make.bottom.equalTo(bottomSheet.snp.bottom)
        }

        selectedPostCollectionView.snp.makeConstraints { make in
            make.top.equalTo(bottomSheet.snp.top).offset(Constants.BottomSheet.PostList.top)
            make.leading.equalTo(bottomSheet.snp.leading)
            make.trailing.equalTo(bottomSheet.snp.trailing)
            make.bottom.equalTo(bottomSheet.snp.bottom)
        }

        writePostButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.bottom.equalTo(view.snp.bottom).offset(-24)
        }

        postEmptyGuideLabel.snp.makeConstraints { make in
            make.centerX.equalTo(bottomSheet.snp.centerX)
            make.top.equalTo(runningTagView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }

        adviseWritingPostView.snp.makeConstraints { make in
            make.centerY.equalTo(writePostButton.snp.centerY)
            make.trailing.equalTo(writePostButton.snp.leading).offset(-4)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return BasicPostCell.size
    }
}

// MARK: - BottomSheet PanGesture

extension HomeViewController {
    enum State {
        enum BottomSheet {
            case open
            case halfOpen
            case closed
        }
    }

    private func isBottomSheetPanGestureEnable(with location: CGPoint) -> Bool {
        if !selectedPostCollectionView.isHidden {
            return false
        }

        let state = bottomSheetState
        if state == .open, postCollectionView.frame.contains(location) {
            return postCollectionView.bounds.origin.y <= 0
        }
        return true
    }

    private func onPanGesture(translation: CGPoint) {
        mapView.isAnnotationHidden = true
        updateBottomSheetPosition(with: translation)
        updateBottomSheetCornerRadius()
        updatePostCollectionView(with: bottomSheetState)
    }

    private func setBottomSheetState(to state: State.BottomSheet, animated: Bool = true, completion: (() -> Void)? = nil) {
        let maxHeight = bottomSheetMaxheight

        switch state {
        case .open:
            bottomSheetHeight.constant = -maxHeight
        case .halfOpen:
            bottomSheetHeight.constant = -Constants.BottomSheet.heightMiddle
        case .closed:
            bottomSheetHeight.constant = -Constants.BottomSheet.heightMin
        }

        updateBottomSheetCornerRadius()
        updatePostCollectionView(with: state)

        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                completion?()
            }
        }

        bottomSheetPanGestureOffsetH = 0
    }

    private func onPanGestureEnded() {
        setBottomSheetState(to: bottomSheetState, completion: { [weak self] in
            self?.mapView.isAnnotationHidden = false
        })
    }

    private var bottomSheetState: State.BottomSheet {
        let maxHeight = bottomSheetMaxheight
        let currentHeight = -bottomSheetHeight.constant

        if currentHeight > Constants.BottomSheet.heightMiddle {
            if currentHeight - Constants.BottomSheet.heightMiddle > maxHeight - currentHeight {
                return .open
            } else {
                return .halfOpen
            }
        } else {
            if currentHeight - Constants.BottomSheet.heightMin > Constants.BottomSheet.heightMiddle - currentHeight {
                return .halfOpen
            } else {
                return .closed
            }
        }
    }

    private var bottomSheetMaxheight: CGFloat {
        return view.frame.height - AppContext.shared.safeAreaInsets.top
    }

    private func updateBottomSheetPosition(with translation: CGPoint) {
        let maxHeight = bottomSheetMaxheight
        let offset = bottomSheetPanGestureOffsetH - translation.y

        let bottomSheetHeight = max(
            -Constants.BottomSheet.heightMin,
            min(maxHeight, -bottomSheetHeight.constant + offset)
        )
        bottomSheetPanGestureOffsetH = translation.y

        self.bottomSheetHeight.constant = -bottomSheetHeight
    }

    private func updateBottomSheetCornerRadius() {
        let maxHeight = bottomSheetMaxheight

        if -bottomSheetHeight.constant > maxHeight - Constants.BottomSheet.cornerRadius {
            bottomSheet.layer.cornerRadius = maxHeight - (-bottomSheetHeight.constant)
        } else {
            bottomSheet.layer.cornerRadius = Constants.BottomSheet.cornerRadius
        }
    }

    private func updatePostCollectionView(with state: State.BottomSheet) {
        switch state {
        case .open:
            postCollectionView.isScrollEnabled = true
        case .halfOpen:
            postCollectionView.isScrollEnabled = false
        case .closed:
            postCollectionView.isScrollEnabled = false
        }
    }
}
