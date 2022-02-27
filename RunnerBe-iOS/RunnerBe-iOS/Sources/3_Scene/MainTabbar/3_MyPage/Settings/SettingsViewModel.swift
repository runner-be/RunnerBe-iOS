//
//  SettingsViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxSwift

final class SettingsViewModel: BaseViewModel {
    override init() {
        super.init()

        let settingItems: [[SettingCellConfig]] = SettingCategory.allCases.reduce(into: []) { partialResult, category in
            let items: [SettingCellConfig]
            switch category {
            case .policyCategory:
                items = PolicyCategory.allCases.reduce(into: []) {
                    $0.append(SettingCellConfig(title: $1.title, details: $1.detail))
                }
            case .aboutRunnerbeCategory:
                items = AboutRunnerbeCategory.allCases.reduce(into: []) {
                    $0.append(SettingCellConfig(title: $1.title, details: $1.detail))
                }
            case .accountCategory:
                items = AccountCategory.allCases.reduce(into: []) {
                    $0.append(SettingCellConfig(title: $1.title, details: $1.detail))
                }
            }
            partialResult.append(items)
        }
        outputs.menus.onNext(settingItems)

        inputs.tapCell
            .subscribe(onNext: { [weak self] indexPath in
                switch indexPath.section {
                case 0:
                    switch indexPath.item {
                    case 1:
                        self?.routes.terms.onNext(())
                    case 2:
                        self?.routes.privacy.onNext(())
                    case 3:
                        self?.routes.license.onNext(())
                    default: break
                    }
                case 1:
                    switch indexPath.item {
                    case 0:
                        self?.routes.makers.onNext(())
                    case 1:
                        self?.routes.instagram.onNext(())
                    default: break
                    }
                case 2:
                    switch indexPath.item {
                    case 0:
                        self?.routes.loggedOut.onNext(())
                    default: break
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var tapCell = PublishSubject<(section: Int, item: Int)>()
        var backward = PublishSubject<Void>()
    }

    struct Output {
        var menus = ReplaySubject<[[SettingCellConfig]]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var terms = PublishSubject<Void>()
        var privacy = PublishSubject<Void>()
        var license = PublishSubject<Void>()
        var makers = PublishSubject<Void>()
        var instagram = PublishSubject<Void>()
        var loggedOut = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
