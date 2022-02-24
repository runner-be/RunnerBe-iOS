//
//  2__0HomeComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol HomeDependency: Dependency {
    var dateService: DateService { get }
    var loginService: LoginService { get }
    var loginKeyChainService: LoginKeyChainService { get }
}

final class HomeComponent: Component<HomeDependency> {
    var scene: (VC: HomeViewController, VM: HomeViewModel) {
        return shared {
            let viewModel = viewModel
            return (VC: HomeViewController(viewModel: viewModel), VM: viewModel)
        }
    }

    var viewModel: HomeViewModel {
        return HomeViewModel(locationService: locationService, mainPageAPIService: mainPageAPIService)
    }

    var locationService: LocationService {
        return shared { BasicLocationService() }
    }

    var mainPageAPIService: PostAPIService {
        return BasicPostAPIService(loginKeyChainService: dependency.loginKeyChainService)
    }

    var writingPostComponent: WritingMainPostComponent {
        return WritingMainPostComponent(parent: self)
    }

    func postFilterComponent(filter: PostFilter) -> HomeFilterComponent {
        return HomeFilterComponent(self, filter: filter)
    }
}
