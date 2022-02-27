//
//  MyPageViewController.swift
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

class MyPageViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInputs()
    }

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
        configureTabItem()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MyPageViewModel

    private func viewModelInput() {
        writtenTab.rx.tap
            .map { MyPageViewModel.PostType.basic }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBags)

        participantTab.rx.tap
            .map { MyPageViewModel.PostType.attendable }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBags)

        myInfoWithChevron.chevronBtn.rx.tap
            .bind(to: viewModel.inputs.editInfo)
            .disposed(by: disposeBags)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.settings)
            .disposed(by: disposeBags)

        postCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        typealias MyPagePostDataSource
            = RxCollectionViewSectionedAnimatedDataSource<MyPagePostSection>

        let dataSource = MyPagePostDataSource { [weak self] _, collectionView, indexPath, item in
            guard let self = self
            else { return UICollectionViewCell() }

            switch self.viewModel.outputs.postType {
            case .attendable:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendablePostCell.id, for: indexPath) as? AttendablePostCell
                else { return UICollectionViewCell() }
                cell.configure(with: item)

                cell.attendButton.rx.tap
                    .map { indexPath.item }
                    .bind(to: self.viewModel.inputs.attend)
                    .disposed(by: cell.disposeBag)

                cell.postInfoView.bookMarkIcon.rx.tap
                    .map { indexPath.item }
                    .bind(to: self.viewModel.inputs.bookMark)
                    .disposed(by: cell.disposeBag)

                self.viewModel.outputs.marked
                    .filter { $0.type == .attendable }
                    .filter { $0.idx == indexPath.item }
                    .subscribe(onNext: { [weak cell] result in
                        cell?.postInfoView.bookMarkIcon.isSelected = result.marked
                    })
                    .disposed(by: cell.disposeBag)

                return cell
            case .basic:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicPostCell.id, for: indexPath) as? BasicPostCell
                else { return UICollectionViewCell() }
                cell.configure(with: item.cellConfig)
                cell.postInfoView.bookMarkIcon.isHidden = true

//                cell.postInfoView.bookMarkIcon.rx.tap
//                    .map { indexPath.item }
//                    .bind(to: self.viewModel.inputs.bookMark)
//                    .disposed(by: cell.disposeBag)

//                self.viewModel.outputs.marked
//                    .filter { $0.type == .basic }
//                    .filter { $0.idx == indexPath.item }
//                    .subscribe(onNext: { [weak cell] result in
//                        cell?.postInfoView.bookMarkIcon.isSelected = result.marked
//                    })
//                    .disposed(by: cell.disposeBag)

                return cell
            }
        }

        viewModel.outputs.posts
            .map { [MyPagePostSection(items: $0)] }
            .bind(to: postCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBags)

        viewModel.outputs.userInfo
            .subscribe(onNext: { [weak self] config in
                self?.myInfoWithChevron.infoView.configure(with: config)
            })
            .disposed(by: disposeBags)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBags)
    }

    private func viewInputs() {
        writtenTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.writtenTab.isSelected = true
                self.hMover.snp.removeConstraints()
                self.hMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(hDivider.snp.bottom)
                    make.leading.equalTo(writtenTab.snp.leading).offset(16)
                    make.trailing.equalTo(writtenTab.snp.trailing).offset(-16)
                }
                self.participantTab.isSelected = false
            })
            .disposed(by: disposeBags)

        participantTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.participantTab.isSelected = true
                self.hMover.snp.removeConstraints()
                self.hMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(hDivider.snp.bottom)
                    make.leading.equalTo(participantTab.snp.leading).offset(16)
                    make.trailing.equalTo(participantTab.snp.trailing).offset(-16)
                }
                self.writtenTab.isSelected = false
            })
            .disposed(by: disposeBags)
    }

    private var myInfoWithChevron = MyInfoViewWithChevron()

    private var writtenTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .selected)
        button.setTitleColor(.darkG25, for: .selected)
        button.setBackgroundColor(.clear, for: .selected)
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .normal)
        button.setTitleColor(.darkG45, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody15R
    }

    private var participantTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .selected)
        button.setTitleColor(.darkG25, for: .selected)
        button.setBackgroundColor(.clear, for: .selected)
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .normal)
        button.setTitleColor(.darkG45, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody15R
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG55
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var hMover = UIView().then { view in
        view.backgroundColor = .darkG25
        view.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }

    private lazy var postCollectionView: UICollectionView = {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(190)
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
        collectionView.register(AttendablePostCell.self, forCellWithReuseIdentifier: AttendablePostCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = ""
        navBar.rightBtnItem.setImage(Asset.settings.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension MyPageViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            myInfoWithChevron,
            writtenTab,
            participantTab,
            hDivider,
            hMover,
            postCollectionView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide
                .snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        myInfoWithChevron.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        writtenTab.snp.makeConstraints { make in
            make.top.equalTo(myInfoWithChevron.snp.bottom).offset(36)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.centerX)
        }

        participantTab.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.top)
            make.leading.equalTo(view.snp.centerX)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        hMover.snp.makeConstraints { make in
            make.bottom.equalTo(hDivider.snp.bottom)
            make.leading.equalTo(writtenTab.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.centerX).offset(-16)
        }

        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func configureTabItem() {
        tabBarItem = UITabBarItem(
            title: "",
            image: Asset.myPageTabIconNormal.uiImage,
            selectedImage: Asset.myPageTabIconFocused.uiImage
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
