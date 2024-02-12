//
//  SettingsViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SafariServices
import SnapKit
import Then
import UIKit

class SettingsViewController: BaseViewController {
    private var viewModel: SettingsViewModel
    private var isOn: String

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SettingsViewModel, isOn: String) {
        self.viewModel = viewModel
        self.isOn = isOn

        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func viewModelInput() {
        tableView.rx.itemSelected
            .map { (section: $0.section, item: $0.item) }
            .bind(to: viewModel.inputs.tapCell)
            .disposed(by: disposeBag)

        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        pushSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(pushSwitch.rx.value)
            .bind(to: viewModel.inputs.switchChanged)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        let dataSource = RxTableViewSectionedReloadDataSource<SettingCategorySection> { [self]
            _, tableView, indexPath, item in

                let cell: UITableViewCell
                if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                    cell = c
                } else {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                }

                if indexPath.section == 0, indexPath.row == 0 {
                    cell.contentView.addSubview(self.pushSwitch)
                    self.pushSwitch.snp.makeConstraints { view in
                        view.trailing.equalTo(cell.snp.trailing).offset(-16)
                        view.centerY.equalTo(cell.snp.centerY)
                    }
                }
                cell.textLabel?.text = item.title
                cell.textLabel?.font = .iosBody15R
                cell.textLabel?.textColor = .darkG1
                cell.detailTextLabel?.text = item.details
                cell.detailTextLabel?.font = .iosBody15R
                cell.detailTextLabel?.textColor = .darkG2
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
        }

        viewModel.outputs.menus
            .map {
                $0.reduce(into: [SettingCategorySection]()) {
                    $0.append(SettingCategorySection(items: $1))
                }
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.routes.instagram
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let instaURL = URL(string: "https://www.instagram.com/runner_be_/?hl=ko")
                else { return }
                let instaSafariView = SFSafariViewController(url: instaURL)
                self.present(instaSafariView, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private lazy var tableView = UITableView(frame: .zero, style: .plain).then { view in
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.delegate = self
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MyPage.Settings.NavBar.title
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var pushSwitch = UISwitch().then { view in
        view.onTintColor = .primary
        view.tintColor = .darkG2
        view.backgroundColor = .darkG2
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
    }
}

// MARK: - Layout

extension SettingsViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            tableView,
        ])

        if isOn == "Y" {
            pushSwitch.isOn = true
        } else {
            pushSwitch.isOn = false
        }
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat { // 섹션 height
        return section == 0 ? 0 : 14
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? { // 섹션 뷰
        if section != 0 {
            let view = UIView()
            view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 14)
            view.backgroundColor = .black
            return view
        }

        return nil
    }
}
