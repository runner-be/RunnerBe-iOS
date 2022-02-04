//
//  0__LoggedOutComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import NeedleFoundation

protocol LoggedOutDependency: Dependency {
    var kakaoOAuthService: KakaoOAuthService { get }
}

class LoggedOutComponent: Component<LoggedOutDependency>, LoggedOutBuilder {
    var loggedOutViewController: UIViewController {
        return shared {
            LoggedOutViewController(viewModel: self.loggedOutViewModel)
        }
    }

    var kakaoOAuthService: KakaoOAuthService {
        return shared {
            KakaoOAuthService()
        }
    }

    var loggedOutViewModel: LoggedOutViewModel {
        return shared {
            LoggedOutViewModel(kakaoOAuthService: kakaoOAuthService)
        }
    }
}

protocol LoggedOutBuilder {}
