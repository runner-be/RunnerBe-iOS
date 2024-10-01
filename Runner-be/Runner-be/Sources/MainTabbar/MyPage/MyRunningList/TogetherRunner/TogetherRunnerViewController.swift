//
//  TogetherRunnerViewController.swift
//  Runner-be
//
//  Created by 김창규 on 9/3/24.
//

import RxDataSources
import UIKit

final class TogetherRunnerViewController: BaseViewController, UIScrollViewDelegate {
    // MARK: - Properties

    private let viewModel: TogetherRunnerViewModel

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "함께한 러너"
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private let titleLabel = UILabel().then {
        $0.text = "함께한 러너 프로필을 터치하여\n 러닝 스탬프를 남겨봐요!"
        $0.textColor = .white
        $0.font = .pretendardSemiBold20
        $0.numberOfLines = 2
    }

    private let countLabel = UILabel().then {
        $0.text = "0명"
        $0.textColor = .darkG4
        $0.font = .pretendardSemiBold20
    }

    private var togetherRunnerTableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(
            TogetherRunnerCell.self,
            forCellReuseIdentifier: TogetherRunnerCell.id
        )

        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Init

    init(viewModel: TogetherRunnerViewModel) {
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

        togetherRunnerTableView.rx.itemSelected
            .do {
                // 이전에 선택된 셀의 isSelected를 false로 설정
                if let selectedIndexPaths = self.togetherRunnerTableView.indexPathsForVisibleRows {
                    selectedIndexPaths.forEach { indexPath in
                        if let cell = self.togetherRunnerTableView.cellForRow(at: indexPath) {
                            cell.isSelected = false
                        }
                    }
                }

                if let cell = self.togetherRunnerTableView.cellForRow(at: $0) as? TogetherRunnerCell {
                    cell.isSelected = true
                }
            }
            .map { $0.item }
            .bind(to: viewModel.inputs.tapRunner)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        togetherRunnerTableView.rx.setDelegate(self).disposed(by: disposeBag)
        typealias TogetherRunnerDataSource = RxTableViewSectionedReloadDataSource<TogetherRunnerSection>

        viewModel.outputs.togetherRunnerList
            .map {
                $0.reduce(into: [TogetherRunnerConfig]()) {
                    $0.append(TogetherRunnerConfig(from: $1))
                }
            }
            .map { [TogetherRunnerSection(items: $0)] }
            .bind(to: togetherRunnerTableView.rx.items(
                dataSource: TogetherRunnerDataSource { [weak self] _, tableView, indexPath, item in
                    guard let self = self,
                          let cell = tableView.dequeueReusableCell(
                              withIdentifier: TogetherRunnerCell.id,
                              for: indexPath
                          ) as? TogetherRunnerCell
                    else { return UITableViewCell() }

                    cell.configure(
                        with: item,
                        index: indexPath.item
                    )

                    cell.showLogButton.rx.tap
                        .map { indexPath.item }
                        .bind(to: self.viewModel.inputs.tapShowLogButton)
                        .disposed(by: cell.disposeBag)

                    return cell
                }
            )).disposed(by: disposeBag)

        viewModel.outputs.togetherRunnerList
            .map { "\($0.count) 명" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension TogetherRunnerViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            titleLabel,
            countLabel,
            togetherRunnerTableView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
        }

        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
        }

        togetherRunnerTableView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(24)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}
