//
//  2__MainTabComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MainTabDependency: Dependency {
    var dateService: DateService { get }
    var loginService: LoginService { get }
    var loginKeyChainService: LoginKeyChainService { get }
}

final class MainTabComponent: Component<MainTabDependency> {
    var sharedScene: (VC: MainTabViewController, VM: MainTabViewModel) {
        shared {
            let viewModel = viewModel
            return (
                VC: MainTabViewController(viewModel: viewModel),
                VM: viewModel
            )
        }
    }

    var viewModel: MainTabViewModel {
        return MainTabViewModel()
    }

    var homeComponent: HomeComponent {
        return HomeComponent(parent: self)
    }

    var bookmarkComponent: BookMarkComponent {
        return BookMarkComponent(parent: self)
    }

    var myPageComponent: MyPageComponent {
        return MyPageComponent(parent: self)
    }

    var postAPIService: PostAPIService {
        return BasicPostAPIService(loginKeyChainService: dependency.loginKeyChainService)
    }
}
