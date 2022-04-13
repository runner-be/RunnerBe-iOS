//
//  2__MainTabComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MainTabDependency: Dependency {}

final class MainTabComponent: Component<MainTabDependency> {
    lazy var scene: (VC: MainTabViewController, VM: MainTabViewModel) = (
        VC: MainTabViewController(viewModel: viewModel),
        VM: viewModel
    )

    lazy var viewModel = MainTabViewModel()

    var homeComponent: HomeComponent {
        return HomeComponent(parent: self)
    }

    var bookmarkComponent: BookMarkComponent {
        return BookMarkComponent(parent: self)
    }

    var myPageComponent: MyPageComponent {
        return MyPageComponent(parent: self)
    }

    var onboardingCoverComponent: OnboardingCoverComponent {
        return OnboardingCoverComponent(parent: self)
    }

    var onboardingWaitCoverComponent: WaitOnboardingCoverComponent {
        return WaitOnboardingCoverComponent(parent: self)
    }
}
