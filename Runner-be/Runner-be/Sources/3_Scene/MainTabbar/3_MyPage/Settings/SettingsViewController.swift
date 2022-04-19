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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: SettingsViewModel

    private func viewModelInput() {
        tableView.rx.itemSelected
            .map { (section: $0.section, item: $0.item) }
            .bind(to: viewModel.inputs.tapCell)
            .disposed(by: disposeBags)

        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        let dataSource = RxTableViewSectionedReloadDataSource<SettingCategorySection> {
            _, tableView, _, item in

            let cell: UITableViewCell
            if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell = c
            } else {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
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
            .disposed(by: disposeBags)

        viewModel.routes.instagram
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let instaURL = URL(string: "https://www.instagram.com/runner_be_/?hl=ko")
                else { return }
                let instaSafariView = SFSafariViewController(url: instaURL)
                self.present(instaSafariView, animated: true, completion: nil)
            })
            .disposed(by: disposeBags)
    }

    private lazy var tableView = UITableView(frame: .zero, style: .plain).then { view in
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.delegate = self
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MyPage.Settings.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.titleLabel.font = .iosBody17Sb
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension SettingsViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            tableView,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.bgBottom.cgColor,
            UIColor.bgTop.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 8
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let view = UIView()
            view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 8)
            view.backgroundColor = .darkG6
            return view
        }

        return nil
    }
}
