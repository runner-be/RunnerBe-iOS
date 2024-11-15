//
//  ConfirmAttendanceViewController.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

final class ConfirmAttendanceViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: ConfirmAttendanceViewModel

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then {
        $0.backgroundColor = .darkG7
        $0.titleLabel.text = "출석 확인하기"
        $0.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        $0.rightBtnItem.isHidden = true
        $0.rightSecondBtnItem.isHidden = true
    }

    private var confirmAttendanceTableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(
            ConfirmAttendanceCell.self,
            forCellReuseIdentifier: ConfirmAttendanceCell.id
        ) // 케이스에 따른 셀을 모두 등록
        $0.separatorStyle = .none
        $0.contentInsetAdjustmentBehavior = .never // 위에 빈 space 있는거 방지
        $0.backgroundColor = .black
    }

    // MARK: - Init

    init(viewModel: ConfirmAttendanceViewModel) {
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

        confirmAttendanceTableView.delegate = self
        confirmAttendanceTableView.dataSource = self
    }

    // MARK: - Methods

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.runnerInfoList
            .bind { [weak self] _ in
                self?.confirmAttendanceTableView.reloadData()

            }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension ConfirmAttendanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _: UITableView,
        numberOfRowsInSection _: Int
    ) -> Int {
        return viewModel.runnerInfoList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConfirmAttendanceCell.id
        ) as? ConfirmAttendanceCell
        else { return .init() }
        cell.selectionStyle = .none
        let runner = viewModel.runnerInfoList[indexPath.item]

        cell.configure(with: runner)

        return cell
    }

    func tableView(
        _: UITableView,
        heightForRowAt _: IndexPath
    ) -> CGFloat {
        return CGFloat(146)
    }
}

// MARK: - Layout

extension ConfirmAttendanceViewController {
    private func setupViews() {
        setBackgroundColor()
        view.addSubviews([
            navBar,
            confirmAttendanceTableView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        confirmAttendanceTableView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}
