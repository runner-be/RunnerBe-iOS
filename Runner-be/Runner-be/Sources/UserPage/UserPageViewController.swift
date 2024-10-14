//
//  UserPageViewController.swift
//  Runner-be
//
//  Created by 김창규 on 10/14/24.
//

import RxDataSources
import RxSwift
import UIKit

final class UserPageViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: UserPageViewModel

    // MARK: - UI

    private let scrollView = UIScrollView(frame: .zero).then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    private let contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    private let navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "{닉네임}님 프로필"
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage, for: .normal)
    }

    private let profileView = MyProfileView()

    private let logStampView = MyLogStampView().then {
        $0.pageControl.currentPage = 2
        $0.logCountView.isHidden = true
        $0.logCountView.snp.makeConstraints {
            $0.height.equalTo(0)
        }
    }

    // TODO: - CollectionView의 HeadrView로 변경
    private let userRunningHeaderView = UIView()
    private let userRunningHeaderTitle = UILabel().then {
        $0.text = "참여한 러닝"
        $0.textColor = .darkG35
        $0.font = .pretendardSemiBold16
    }

    private let userRunningHeaderIcon = UIImageView().then {
        $0.image = Asset.chevronRight.uiImage
    }

    private lazy var userRunningCollectionView: UICollectionView = { // 참여 러닝 탭
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPageParticipateCell.self, forCellWithReuseIdentifier: MyPageParticipateCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = false
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Init

    init(viewModel: UserPageViewModel) {
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
    }

    private func viewModelOutput() {
        userRunningCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        logStampView.logStampCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.outputs.userInfo
            .subscribe(onNext: { [weak self] userConfig in
                self?.profileView.configure(with: userConfig)
                self?.navBar.titleLabel.text = "\(userConfig.nickName)님 프로필"
            }).disposed(by: disposeBag)

        typealias MyLogStampDataSource = RxCollectionViewSectionedAnimatedDataSource<MyLogStampSection>

        let myLogStampDatasource = MyLogStampDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let _ = self,
                      let cell = collectionView.dequeueReusableCell(
                          withReuseIdentifier: MyLogStampCell.id,
                          for: indexPath
                      ) as? MyLogStampCell
                else {
                    return UICollectionViewCell()
                }

                cell.configure(with: LogStamp(
                    logId: nil,
                    gatheringId: nil,
                    date: element.date,
                    stampType: element.stampType
                ))

                return cell
            }
        )

        viewModel.outputs.logStamps
            .debug("logStamps")
            .bind(to: logStampView.logStampCollectionView.rx.items(dataSource: myLogStampDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.logStamps
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                // 콜렉션 뷰가 리로드된 후 특정 아이템으로 스크롤
                self.logStampView.logStampCollectionView.scrollToItem(
                    at: IndexPath(
                        item: 0,
                        section: self.logStampView.pageControl.currentPage
                    ),
                    at: .left,
                    animated: false
                )
            })
            .disposed(by: disposeBag)

        typealias MyPagePostDataSource
            = RxCollectionViewSectionedAnimatedDataSource<MyPagePostSection>

        let userRunningDatasource = MyPagePostDataSource { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageParticipateCell.id, for: indexPath) as? MyPageParticipateCell
            else { return UICollectionViewCell() }

            cell.configure(with: item)

            return cell
        }

        viewModel.outputs.posts
            .map { [MyPagePostSection(items: $0)] }
            .bind(to: userRunningCollectionView.rx.items(dataSource: userRunningDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.changeTargetDate
            .map { "\($0.year)년 \($0.month)월" }
            .bind(to: logStampView.dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - User

extension UserPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        switch collectionView {
        case let c where c == userRunningCollectionView:
            return MyPageParticipateCell.size
        case let c where c == logStampView.logStampCollectionView:
            return MyLogStampCell.size
        default:
            return .zero
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch scrollView {
        case userRunningCollectionView:
            return
        case logStampView.logStampCollectionView:
            let estimatedIndex = targetContentOffset.pointee.x / logStampView.logStampCollectionView.bounds.width
            let index: CGFloat

            index = round(estimatedIndex)
            let offsetX = CGFloat(index) * logStampView.logStampCollectionView.bounds.width - 32
            targetContentOffset.pointee = CGPoint(x: offsetX, y: 0)
            logStampView.pageControl.currentPage = Int(index)
        default:
            return
        }
    }
}

// MARK: - Layout

extension UserPageViewController {
    private func setupViews() {
        setBackgroundColor()
        view.addSubviews([
            navBar,
            scrollView,
        ])

        scrollView.addSubview(contentView)

        contentView.addSubviews([
            profileView,
            logStampView,
            userRunningHeaderView,
            userRunningCollectionView,
        ])

        userRunningHeaderView.addSubviews([
            userRunningHeaderTitle,
            userRunningHeaderIcon,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.left.bottom.right.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height).priority(.low)
        }

        profileView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }

        logStampView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
        }

        userRunningHeaderView.snp.makeConstraints {
            $0.top.equalTo(logStampView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }

        userRunningHeaderTitle.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
        }

        userRunningHeaderIcon.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.size.equalTo(24)
        }
        userRunningCollectionView.backgroundColor = .orange
        userRunningCollectionView.snp.makeConstraints { make in
            make.top.equalTo(userRunningHeaderView.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
            make.height.equalTo(208)
        }
    }
}
