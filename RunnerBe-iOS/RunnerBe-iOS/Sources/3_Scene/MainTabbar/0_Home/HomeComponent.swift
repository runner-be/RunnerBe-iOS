//
//  2__0HomeComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol HomeDependency: Dependency {
    var loginService: LoginService { get }
    var loginKeyChainService: LoginKeyChainService { get }
    var postAPIService: PostAPIService { get }
    var locationService: LocationService { get }
}

final class HomeComponent: Component<HomeDependency> {
    var sharedScene: (VC: HomeViewController, VM: HomeViewModel) {
        return shared {
            let viewModel = viewModel
            return (VC: HomeViewController(viewModel: viewModel), VM: viewModel)
        }
    }

    var viewModel: HomeViewModel {
        return HomeViewModel(locationService: dependency.locationService, postAPIService: dependency.postAPIService)
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(parent: self, postId: postId)
    }

    var writingPostComponent: WritingMainPostComponent {
        return WritingMainPostComponent(parent: self)
    }

    func postFilterComponent(filter: PostFilter) -> HomeFilterComponent {
        return HomeFilterComponent(self, filter: filter)
    }
}
