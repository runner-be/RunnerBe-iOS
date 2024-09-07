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
            receivedStampListView,
            hDivider3,
            privacyToggleView,
            registerButton,
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

    private let receivedStampListView = ReceivedStampListView()

    private let hDivider3 = UIView().then {
        $0.backgroundColor = .darkG6
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

    private let privacyToggleView = WriteLogToggleView().then {
        $0.toggleButton.layer.opacity = 0.3
        $0.isUserInteractionEnabled = false
    }

    private let registerButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.darkG6, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold15
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .primary
    }

    // MARK: - Init

    init(viewModel: ConfirmLogViewModel) {
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
            .map { true }
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.routes.modal)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.logDate
            .bind(to: navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)

        receivedStampListView.stampCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        // 나의 로그 스탬프
        typealias ReceivedStampDataSource = RxCollectionViewSectionedAnimatedDataSource<ReceivedStampSection>

        let receivedStampDatasource = ReceivedStampDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let self = self else { return UICollectionViewCell() }

                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceivedStampCell.id, for: indexPath) as? ReceivedStampCell
                else { return UICollectionViewCell() }
                print("seijfsljf 123114214")
                cell.configure(receivedStamp: .init(
                    userName: element.userName,
                    userProfileURL: element.userProfileURL,
                    stampStatus: element.stampStatus
                ))
                return cell
            }
        )

        viewModel.outputs.receivedStamps
            .map {
                print("seijfsljf :: \($0)")
                return [ReceivedStampSection(items: $0)]
            }
            .bind(to: receivedStampListView.stampCollectionView.rx.items(dataSource: receivedStampDatasource))
            .disposed(by: disposeBag)
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

        receivedStampListView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }

        registerButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }

        privacyToggleView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
