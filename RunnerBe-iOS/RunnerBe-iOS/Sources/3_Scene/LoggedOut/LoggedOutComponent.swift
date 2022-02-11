//
//  0__LoggedOutComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import NeedleFoundation

protocol LoggedOutDependency: Dependency {
    var kakaoLoginService: KakaoLoginService { get }
    var naverLoginService: NaverLoginService { get }
}

class LoggedOutComponent: Component<LoggedOutDependency> {
    var scene: (VC: UIViewController, VM: LoggedOutViewModel) {
        let viewModel = self.viewModel
        return (LoggedOutViewController(viewModel: viewModel), viewModel)
    }

    var kakaoLoginService: KakaoLoginService {
        return shared {
            KakaoLoginService()
        }
    }

    var naverLoginService: NaverLoginService {
        return shared {
            NaverLoginService()
        }
    }

    var viewModel: LoggedOutViewModel {
        return LoggedOutViewModel(
                kakaoLoginService: kakaoLoginService,
                naverLoginService: naverLoginService
            )
    }

    var policyTermComponent: PolicyTermComponent {
        return PolicyTermComponent(parent: self)
    }
}
