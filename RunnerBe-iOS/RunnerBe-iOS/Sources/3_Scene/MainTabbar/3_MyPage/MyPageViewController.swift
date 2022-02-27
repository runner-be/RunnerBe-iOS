//
//  MyPageViewController.swift
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

class MyPageViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
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

    private func viewModelInput() {}
    private func viewModelOutput() {}

    private var myInfoWithChevron = MyInfoViewWithChevron()

    private var writtenTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .normal)
        button.setTitleColor(.darkG25, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .disabled)
        button.setTitleColor(.darkG45, for: .disabled)
        button.setBackgroundColor(.clear, for: .disabled)
        button.titleLabel?.font = .iosBody15R
    }

    private var participantTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .normal)
        button.setTitleColor(.darkG25, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .disabled)
        button.setTitleColor(.darkG45, for: .disabled)
        button.setBackgroundColor(.clear, for: .disabled)
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
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.centerX)
        }

        participantTab.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.top)
            make.leading.equalTo(view.snp.centerX)
            make.trailing.equalTo(view.snp.trailing)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        hMover.snp.makeConstraints { make in
            make.bottom.equalTo(hDivider.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.centerX)
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
