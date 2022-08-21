//
//  AlarmListViewController.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

class AlarmListViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: AlarmListViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: AlarmListViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        alarmListTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.alarmListTableView.cellForRow(at: indexPath) as? AlarmCell else { return }
                cell.checkAlarm(isNew: false)
            })
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
//        alarmCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        typealias AlarmListDataSource = RxTableViewSectionedAnimatedDataSource<AlarmListSection>

        viewModel.outputs.alarmList
            .map {
                $0.reduce(into: [AlarmCellConfig]()) {
                    $0.append(AlarmCellConfig(from: $1))
                }
            }
            .map { [AlarmListSection(items: $0)] }
            .bind(to: alarmListTableView.rx.items(dataSource: AlarmListDataSource { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmCell.id, for: indexPath) as? AlarmCell
                else { return UITableViewCell() }

                cell.configure(with: item)
                return cell
            }))
            .disposed(by: disposeBag)
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = "알림"
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)

        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
        navBar.titleSpacing = 12
    }

    private lazy var alarmListTableView: UITableView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.minimumLineSpacing = 0
//        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(AlarmCell.self, forCellWithReuseIdentifier: AlarmCell.id)
//        collectionView.backgroundColor = .clear
//        return collectionView
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(AlarmCell.self, forCellReuseIdentifier: AlarmCell.id)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
}

// MARK: - Layout

extension AlarmListViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            alarmListTableView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        alarmListTableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
}
