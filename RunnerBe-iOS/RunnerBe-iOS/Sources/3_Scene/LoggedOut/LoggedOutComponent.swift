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
    var loggedOutViewController: UIViewController {
        return shared {
            LoggedOutViewController(viewModel: self.loggedOutViewModel)
        }
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

    var loggedOutViewModel: LoggedOutViewModel {
        return shared {
            LoggedOutViewModel(
                kakaoLoginService: kakaoLoginService,
                naverLoginService: naverLoginService
            )
        }
    }
}
