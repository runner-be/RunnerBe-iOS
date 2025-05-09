//
//  MyRunningListViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/29/24.
//

import RxDataSources
import UIKit

final class MyRunningListViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: MyRunningListViewModel

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "참여한 러닝"
        navBar.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private let buttonStackView = UIStackView().then {
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .white.withAlphaComponent(0.04)
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    private let allTypeButton = UIButton().then {
        $0.titleLabel?.font = .pretendardSemiBold14
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(.darkG45, for: .normal)
        $0.setTitleColor(.darkG6, for: .selected)
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .primary
        $0.isSelected = true
    }

    private let createdTypeButton = UIButton().then {
        $0.titleLabel?.font = .pretendardSemiBold14
        $0.setTitle("내가 만든 모임", for: .normal)
        $0.setTitleColor(.darkG45, for: .normal)
        $0.setTitleColor(.darkG6, for: .selected)
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .clear
        $0.isSelected = false
    }

    private let totalCountLabel = UILabel().then {
        $0.text = "총 0건"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private lazy var postCollectionView: UICollectionView = { // 작성 글 탭
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = false
        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Init

    init(viewModel: MyRunningListViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()

        viewInput()
        viewModelInput()
        viewModelOutput()
    }

    private func viewInput() {
        allTypeButton.rx.tap
            .bind { [weak self] _ in
                self?.allTypeButton.isSelected = true
                self?.allTypeButton.backgroundColor = .primary
                self?.createdTypeButton.isSelected = false
                self?.createdTypeButton.backgroundColor = .clear
            }.disposed(by: disposeBag)

        createdTypeButton.rx.tap
            .bind { [weak self] _ in
                self?.allTypeButton.isSelected = false
                self?.allTypeButton.backgroundColor = .clear
                self?.createdTypeButton.isSelected = true
                self?.createdTypeButton.backgroundColor = .primary
            }.disposed(by: disposeBag)
    }

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)

        allTypeButton.rx.tap
            .map { MyRunningListViewModel.PostType.all }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBag)

        createdTypeButton.rx.tap
            .map { MyRunningListViewModel.PostType.myPost }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBag)

        postCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        postCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        typealias PostDataSource = RxCollectionViewSectionedAnimatedDataSource<PostSection>
        let postDataSource = PostDataSource { [weak self] _, collectionView, indexPath, item in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(
                      withReuseIdentifier: PostCell.id,
                      for: indexPath
                  ) as? PostCell
            else {
                return UICollectionViewCell()
            }

            cell.configure(with: item)

            cell.postInfoView.bookMarkIcon.rx.tap
                .map { indexPath.item }
                .subscribe(onNext: { [weak self] index in
                    self?.viewModel.inputs.bookMark.onNext(index)
                }).disposed(by: cell.disposeBag)

            cell.manageAttendanceButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapManageAttendance)
                .disposed(by: cell.disposeBag)

            cell.confirmAttendanceButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapConfirmAttendance)
                .disposed(by: cell.disposeBag)

            cell.writeLogButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapWriteLog)
                .disposed(by: cell.disposeBag)

            cell.confirmLogButton.rx.tapGesture()
                .when(.recognized)
                .map { _ in indexPath.item }
                .bind(to: viewModel.inputs.tapConfirmLog)
                .disposed(by: cell.disposeBag)

            return cell
        }

        viewModel.outputs.newPosts
            .map { [PostSection(items: $0)] }
            .bind(to: postCollectionView.rx.items(dataSource: postDataSource))
            .disposed(by: disposeBag)

        viewModel.outputs.newPosts
            .map { "총 \($0.count)건" }
            .bind(to: totalCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension MyRunningListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 208)
    }
}

// MARK: - Layout

extension MyRunningListViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            buttonStackView,
            totalCountLabel,
            postCollectionView,
        ])

        buttonStackView.addArrangedSubviews([
            allTypeButton,
            createdTypeButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }

        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
        }

        postCollectionView.snp.makeConstraints {
            $0.top.equalTo(totalCountLabel.snp.bottom).offset(24)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}
