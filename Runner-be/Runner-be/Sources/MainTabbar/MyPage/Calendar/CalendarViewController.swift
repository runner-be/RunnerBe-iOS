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

                cell.configure(with: LogStamp(
                    date: element.date,
                    stampType: element.stampType
                ))

                return cell
            })

        viewModel.outputs.days
            .debug("Calendar")
            .map { [MyLogStampSection(items: $0)] }
            .bind(to: calendarCollectionView.rx.items(dataSource: calendarDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.changedTargetDate
            .bind { [weak self] targetDate in
                self?.dateLabel.label.text = "\(targetDate.year)년 \(targetDate.month)월"
            }.disposed(by: disposeBag)

        viewModel.outputs.logTotalCount
            .bind { [weak self] logTotalCount in
                self?.updateCountLabel(with: logTotalCount)
            }
            .disposed(by: disposeBag)
    }

    func updateCountLabel(with logTotalCount: LogTotalCount) {
        if logTotalCount.groupRunningCount == 0 &&
            logTotalCount.personalRunningCount == 0
        {
            logCountEmptyLabel.text = "이달의 스탬프를 채워봐요!"
            return
        }

        // 기본 텍스트 설정
        let groupText = "크루 \(logTotalCount.groupRunningCount)회"
        let personalText = "개인 \(logTotalCount.personalRunningCount)회"
        let fullText = "\(groupText) ㆍ \(personalText)"

        // NSMutableAttributedString으로 변환
        let attributedText = NSMutableAttributedString(string: fullText)

        // 숫자 부분의 범위 계산
        let groupCountRange = (fullText as NSString).range(of: "\(logTotalCount.groupRunningCount)회")
        let personalCountRange = (fullText as NSString).range(of: "\(logTotalCount.personalRunningCount)회")

        // 원하는 폰트와 색상 설정
        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendardSemiBold14,
            .foregroundColor: UIColor.darkG2,
        ]

        // 숫자 부분에 스타일 적용
        attributedText.addAttributes(highlightAttributes, range: groupCountRange)
        attributedText.addAttributes(highlightAttributes, range: personalCountRange)

        // 라벨에 적용
        logCountEmptyLabel.attributedText = attributedText
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
