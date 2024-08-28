//
//  CalendarViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import RxDataSources
import SnapKit
import UIKit

final class CalendarViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: CalendarViewModel
    private var collectionViewHeightConstraint: Constraint?

    // MARK: - UI

    private let hStackView = UIStackView.make(
        with: ["월", "화", "수", "목", "금", "토", "일"].map { text in
            UILabel().then { label in
                label.font = .pretendardSemiBold16
                label.text = text
                label.textColor = .darkG45
                label.textAlignment = .center
            }
        },
        axis: .horizontal,
        alignment: .center,
        distribution: .fillEqually,
        spacing: 0
    )

    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        var collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            MyLogStampCell.self,
            forCellWithReuseIdentifier: MyLogStampCell.id
        )
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .zero
        return collectionView
    }()

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "캘린더"
        navBar.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var dateLabel = IconLabel(
        iconPosition: .right,
        iconSize: CGSize(width: 24, height: 24),
        spacing: 0,
        padding: .zero
    ).then {
        $0.icon.image = Asset.chevronDownNew.uiImage
        $0.label.font = .pretendardSemiBold16
        $0.label.textColor = .darkG35
        $0.label.text = "2000년 00월"
    }

    private let logCountView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .darkG6
    }

    private let logCountEmptyLabel = UILabel().then {
        $0.text = "이달의 스탬프를 채워봐요!"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular14
    }

    // MARK: - Init

    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init()
        dateLabel.label.text = "\(viewModel.year)년 \(viewModel.month)월"
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 컬렉션 뷰의 콘텐츠 크기에 맞춰 높이 조정
        collectionViewHeightConstraint?.update(offset: calendarCollectionView.collectionViewLayout.collectionViewContentSize.height)
    }

    // MARK: - Methods

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)

        dateLabel.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.showSelectDate)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        calendarCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        typealias CalendarDataSource = RxCollectionViewSectionedAnimatedDataSource<MyLogStampSection>

        let calendarDatasource = CalendarDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let _ = self,
                      let cell = collectionView.dequeueReusableCell(
                          withReuseIdentifier: MyLogStampCell.id,
                          for: indexPath
                      ) as? MyLogStampCell
                else {
                    return UICollectionViewCell()
                }

                cell.configure(
                    dayOfWeek: element.dayOfWeek,
                    date: element.date
                )

                return cell
            })

        viewModel.outputs.days
            .debug("Calendar")
            .map { [MyLogStampSection(items: $0)] }
            .bind(to: calendarCollectionView.rx.items(dataSource: calendarDatasource))
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension CalendarViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            dateLabel,
            hStackView,
            calendarCollectionView,
            logCountView,
        ])

        logCountView.addSubviews([
            logCountEmptyLabel,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(16)
        }

        hStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(18)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(38)
        }

        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom)
            $0.left.right.equalToSuperview().inset(16)
            collectionViewHeightConstraint = $0.height.equalTo(400).constraint // 초기 높이 설정
        }

        logCountView.snp.makeConstraints {
            $0.top.equalTo(calendarCollectionView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }

        logCountEmptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        print("feisjflnse9fjesf :\((UIScreen.main.bounds.width - 32) / 7)")
        switch collectionView {
        case let c where c == calendarCollectionView:
            return MyLogStampCell.size
        default:
            return .zero
        }
    }
}
