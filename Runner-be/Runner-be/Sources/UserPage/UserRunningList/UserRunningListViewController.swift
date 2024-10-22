//
//  UserRunningListViewController.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import RxDataSources
import RxSwift
import UIKit

final class UserRunningListViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: UserRunningListViewModel

    // MARK: - UI

    private let navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "{닉네임}님 참여한 러닝"
        navBar.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private let totalCountLabel = UILabel().then {
        $0.text = "총 0건"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private lazy var userRunningCollectionView: UICollectionView = { // 작성 글 탭
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserPageParticipateCell.self, forCellWithReuseIdentifier: UserPageParticipateCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = false
        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Init

    init(viewModel: UserRunningListViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    // MARK: - Methods

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)
        
        userRunningCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        userRunningCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        typealias RunningDataSource
            = RxCollectionViewSectionedAnimatedDataSource<UserPagePostSection>

        let userRunningDatasource = RunningDataSource { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageParticipateCell.id, for: indexPath) as? UserPageParticipateCell
            else { return UICollectionViewCell() }

            cell.configure(with: item)
            return cell
        }

        viewModel.outputs.nickName
            .map { "\($0)님 참여한 러닝" }
            .bind(to: navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.postCount
            .map { "총 \($0)건" }
            .bind(to: totalCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.posts
            .map { [UserPagePostSection(items: $0)] }
            .bind(to: userRunningCollectionView.rx.items(dataSource: userRunningDatasource))
            .disposed(by: disposeBag)
    }
}

extension UserRunningListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return UserPageParticipateCell.size
    }
}

// MARK: - Layout

extension UserRunningListViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            totalCountLabel,
            userRunningCollectionView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
        }

        userRunningCollectionView.snp.makeConstraints {
            $0.top.equalTo(totalCountLabel.snp.bottom).offset(24)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}
