//
//  MainTabComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation

final class MainTabComponent {
    lazy var scene: (VC: MainTabViewController, VM: MainTabViewModel) = (
        VC: MainTabViewController(viewModel: viewModel),
        VM: viewModel
    )

    lazy var viewModel = MainTabViewModel()

    var homeComponent: HomeComponent {
        return HomeComponent()
    }

    var bookmarkComponent: BookMarkComponent {
        return BookMarkComponent()
    }

    var messageComponent: MessageComponent {
        return MessageComponent()
    }

    var myPageComponent: MyPageComponent {
        return MyPageComponent()
    }

    var onboardingCoverComponent: OnboardingCoverComponent {
        return OnboardingCoverComponent()
    }
}
