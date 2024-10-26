//
//  LogStampBottomSheetViewController.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import RxDataSources
import RxSwift
import UIKit

final class LogStampBottomSheetViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: LogStampBottomSheetViewModel

    // MARK: - UI

    private let backgroundView = UIView()

    private let bottomSheetBg = UIView().then {
        $0.backgroundColor = .darkG55
        $0.layer.cornerRadius = 12
    }

    private let bottomHandle = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 1.5
    }

    private let titleLabel = UILabel().then {
        $0.text = "스탬프"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold20
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    private lazy var stampCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        var collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            LogStampCell.self,
            forCellWithReuseIdentifier: LogStampCell.id
        )
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0)

        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let stampTitleLabel = UILabel().then {
        $0.text = "Stamp Title"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold20
        $0.textAlignment = .center
    }

    private let stampSubTitleLabel = UILabel().then {
        $0.text = "Stamp SubTitle"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular16
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    private let registerButton = UIButton().then {
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 24
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.darkG6, for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold16
    }

    // MARK: - Init

    init(
        viewModel: LogStampBottomSheetViewModel,
        title: String
    ) {
        self.viewModel = viewModel
        titleLabel.text = title
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()

        // 기본 선택 값
//        let indexPath = IndexPath(item: 0, section: 0)
//        stampCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
//        print("seijfsljfsljf 222")
//        viewModel.inputs.tapStamp.onNext(0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBottomSheet()
    }

    // MARK: - Methods

    private func viewModelInput() {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)

        stampCollectionView.rx.itemSelected
            .map { test in
                print("sejifesljfse: \(test)")
                return test.item
            }
            .bind(to: viewModel.inputs.tapStamp)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .bind(to: viewModel.inputs.register)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        stampCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        typealias LogStampDataSource = RxCollectionViewSectionedAnimatedDataSource<LogStampSection>

        let logStampDatasource = LogStampDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let _ = self,
                      let cell = collectionView.dequeueReusableCell(
                          withReuseIdentifier: LogStampCell.id,
                          for: indexPath
                      ) as? LogStampCell
                else {
                    return UICollectionViewCell()
                }

                if let stampType = element.stampType {
                    cell.configure(
                        with: stampType,
                        isEnabled: element.isEnabled
                    )
                }

                return cell
            }
        )

        viewModel.outputs.logStamps
            .map { [LogStampSection(items: $0)] }
            .bind(to: stampCollectionView.rx.items(dataSource: logStampDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.selectedStamp
            .bind { [weak self] outputs in
                guard let self = self else { return }

                self.stampCollectionView.selectItem(
                    at: IndexPath(item: outputs.index, section: 0),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
                self.stampTitleLabel.text = outputs.stampType.title
                self.stampSubTitleLabel.text = outputs.stampType.subTitle
            }.disposed(by: disposeBag)
    }

    private func animateBottomSheet() {
        let bottomSheetHeight = bottomSheetBg.frame.height
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.bottomSheetBg.snp.updateConstraints {
                $0.top.equalTo(self.view.snp.bottom).offset(-bottomSheetHeight)
            }
            self.view.layoutIfNeeded()
        })
    }
}

extension LogStampBottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        LogStampCell.size
    }
}

// MARK: - Layout

extension LogStampBottomSheetViewController {
    private func setupViews() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubviews([
            backgroundView,
            bottomSheetBg,
        ])

        bottomSheetBg.addSubviews([
            bottomHandle,
            titleLabel,
            stampCollectionView,
            stampTitleLabel,
            stampSubTitleLabel,
            registerButton,
        ])
    }

    private func initialLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }

        bottomSheetBg.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.snp.bottom)
            $0.height.greaterThanOrEqualTo(369)
        }

        bottomHandle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(37)
            $0.height.equalTo(3)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomHandle.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        stampCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(64)
        }

        stampTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stampCollectionView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        stampSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stampTitleLabel.snp.bottom).offset(8)
            $0.left.right.equalTo(stampTitleLabel)
            $0.height.equalTo(44)
        }

        registerButton.snp.makeConstraints {
            $0.top.equalTo(stampSubTitleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(38)
            $0.height.equalTo(48)
        }
    }
}
