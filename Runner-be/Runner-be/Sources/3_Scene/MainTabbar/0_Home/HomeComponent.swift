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
    lazy var scene: (VC: HomeViewController, VM: HomeViewModel) = (VC: HomeViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: HomeViewModel = .init(locationService: dependency.locationService, postAPIService: dependency.postAPIService, loginKeyChainService: dependency.loginKeyChainService)

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
