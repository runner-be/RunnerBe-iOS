//
//  SettingConfigItems.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Foundation
import RxDataSources

struct SettingCategorySection {
    var items: [Item]
}

extension SettingCategorySection: SectionModelType {
    typealias Item = SettingCellConfig

    init(original: SettingCategorySection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct SettingCellConfig {
    let title: String
    let details: String
}

enum SettingCategory: CaseIterable {
    case pushCategory
    case policyCategory
    case aboutRunnerbeCategory
    case accountCategory
}

enum PushCategory: CaseIterable {
    case push
}

enum PolicyCategory: CaseIterable {
    case version
    case term
    case privacy
}

enum AboutRunnerbeCategory: CaseIterable {
    case makers
    case instagram
}

enum AccountCategory: CaseIterable {
    case loggedOut
    case signOut
}

extension PushCategory {
    var title: String {
        return L10n.MyPage.Settings.Push.title
    }

    var detail: String { "" }
}

extension PolicyCategory {
    var title: String {
        switch self {
        case .version:
            return L10n.MyPage.Settings.Category.Policy.Version.title
        case .term:
            return L10n.MyPage.Settings.Category.Policy.Term.title
        case .privacy:
            return L10n.MyPage.Settings.Category.Policy.Privacy.title
        }
    }

    var detail: String {
        switch self {
        case .version:
            return "1.2.3"
        default:
            return ""
        }
    }
}

extension AboutRunnerbeCategory {
    var title: String {
        switch self {
        case .makers:
            return L10n.MyPage.Settings.Category.AboutRunnerbe.Maker.title
        case .instagram:
            return L10n.MyPage.Settings.Category.AboutRunnerbe.Instagram.title
        }
    }

    var detail: String { "" }
}

extension AccountCategory {
    var title: String {
        switch self {
        case .loggedOut:
            return L10n.MyPage.Settings.Category.Account.Logout.title
        case .signOut:
            return L10n.MyPage.Settings.Category.Account.SignOut.title
        }
    }

    var detail: String { "" }
}
