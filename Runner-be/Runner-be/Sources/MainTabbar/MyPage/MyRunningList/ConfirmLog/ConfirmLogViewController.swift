//
//  ConfirmLogViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import RxDataSources
import RxSwift
import UIKit

final class ConfirmLogViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: ConfirmLogViewModel

    private let loginKeyChain: LoginKeyChainService

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then {
        $0.titleLabel.text = "2024년 0월 0일 월요일 22 "
        $0.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        $0.rightBtnItem.setImage(Asset.iconMoreButton24.uiImage.withTintColor(.darkG3), for: .normal)
        $0.rightSecondBtnItem.isHidden = true
    }

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }

    private lazy var vStackView = UIStackView.make(
        with: [
            logStampView,
            hDivider1,
            logDiaryView,
            hDivider2,
            gotStampListView,
            hDivider3,
            privacyToggleView,
            UIView(),
        ],
        axis: .vertical,
        spacing: 24
    )

    private let logStampView = WriteLogStampView()

    private var hDivider1 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let logDiaryView = WriteLogDiaryView(type: .confirm)

    private let hDivider2 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let gotStampListView = GotStampListView()

    private let hDivider3 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let privacyToggleView = WriteLogToggleView().then {
        $0.toggleButton.layer.opacity = 0.3
        $0.isUserInteractionEnabled = false
        $0.toggleButton.isOn = false
    }

    // MARK: - Init

    init(
        viewModel: ConfirmLogViewModel,
        loginKeyChain: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        self.viewModel = viewModel
        self.loginKeyChain = loginKeyChain
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
        viewModel.routeInputs.needUpdate.onNext(true)

        navBar.leftBtnItem.rx.tap
            .map { true }
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.routes.modal)
            .disposed(by: disposeBag)

        logDiaryView.participantView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.tapTogether)
            .disposed(by: disposeBag)

        gotStampListView.stampCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapGotStamp)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.logDate
            .bind(to: navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)

        gotStampListView.stampCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        // 나의 로그 스탬프
        typealias ReceivedStampDataSource = RxCollectionViewSectionedAnimatedDataSource<ReceivedStampSection>

        let gotStampDatasource = ReceivedStampDataSource(
            configureCell: { _, collectionView, indexPath, element -> UICollectionViewCell in

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceivedStampCell.id, for: indexPath) as? ReceivedStampCell
                else { return UICollectionViewCell() }

                cell.configure(with: GotStamp(
                    userId: element.userId,
                    logId: element.logId,
                    nickname: element.nickname,
                    profileImageUrl: element.profileImageUrl,
                    stampCode: element.stampCode
                ))

                return cell
            }
        )

        viewModel.outputs.logDetail
            .bind { [weak self] logDetail in
                self?.update(with: logDetail)
            }.disposed(by: disposeBag)

        viewModel.outputs.gotStamps
            .map { [ReceivedStampSection(items: $0)] }
            .bind(to: gotStampListView.stampCollectionView.rx.items(dataSource: gotStampDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.showBubbleInfo
            .bind { [weak self] _ in
                self?.logDiaryView.showInfoWordBubble()
            }.disposed(by: disposeBag)
    }

    private func update(with logDetail: LogDetail) {
        // navbar 날짜 타이틀
        navBar.titleLabel.text = logDetail.runningDateString

        // navBar 우측 더보기 메뉴 버튼
        navBar.rightBtnItem.isHidden = logDetail.detailRunningLog.userId != loginKeyChain.userId

        // 러닝 로그
        logStampView.update(stampType: logDetail.runningStamp)

        // 러닝 일기 작성 글
        logDiaryView.textView.text = logDetail.contents
        logDiaryView.textView.placeholder = ""
        logDiaryView.textView.snp.updateConstraints {
            $0.height.equalTo(logDiaryView.textView.contentSize.height)
        }
        // 러닝 일기 사진
        logDiaryView.confirmImageView.kf.setImage(with: URL(string: logDetail.imageURL ?? ""))

        // 날씨
        logDiaryView.updateWeather(
            stamp: logDetail.weatherStamp,
            degree: logDetail.weatherDegree
        )

        // 함께한 러너
        logDiaryView.updateGathering(
            gatheringCount: logDetail.gatheringCount,
            gatheringId: logDetail.detailRunningLog.gatheringId
        )

        // 받은 스탬프
        if logDetail.gotStamp.isEmpty {
            vStackView.removeArrangedSubview(gotStampListView)
            gotStampListView.removeFromSuperview() // 실제 뷰도 제거
            vStackView.removeArrangedSubview(hDivider3)
            hDivider3.removeFromSuperview() // 실제 뷰도 제거
        }

        // 공개 설정
        privacyToggleView.toggleButton.isOn = logDetail.isOpened

        // 타인이면 공개설정 숨김 처리
        privacyToggleView.isHidden = logDetail.detailRunningLog.userId != loginKeyChain.userId
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConfirmLogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return ReceivedStampCell.size
    }
}

// MARK: - Layout

extension ConfirmLogViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            scrollView,
        ])

        scrollView.addSubview(vStackView)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }

        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        logDiaryView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }

        gotStampListView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }

        privacyToggleView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
