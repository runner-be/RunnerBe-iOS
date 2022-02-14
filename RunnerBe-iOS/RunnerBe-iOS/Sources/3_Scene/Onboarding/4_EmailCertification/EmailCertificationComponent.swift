//
//  EmailCertificationComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import NeedleFoundation

protocol EmailCertificationDependency: Dependency {
    var loginKeyChainService: LoginKeyChainService { get }
    var signupKeyChainService: SignupKeyChainService { get }
}

final class EmailCertificationComponent: Component<EmailCertificationDependency> {
    var scene: (VC: UIViewController, VM: EmailCertificationViewModel) {
        let viewModel = viewModel
        return (EmailCertificationViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: EmailCertificationViewModel {
        return EmailCertificationViewModel()
    }

    var photoCertificationComponent: PhotoCertificationComponent {
        return PhotoCertificationComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }

    var initModalComponent: EmailCertificationInitModalComponent {
        return EmailCertificationInitModalComponent(parent: self)
    }

    var signupService: SignupService {
        return shared { BasicSignupService(
            loginKeyChainService: dependency.loginKeyChainService,
            signupKeyChainService: dependency.signupKeyChainService,
            signupAPIService: signupAPIService,
            emailCertificationService: emailCertificationService,
            imageUploadService: imageUploadService,
            randomNickNameGenerator: randomNickNameGenerator
        )
        }
    }

    private var signupAPIService: SignupAPIService {
        return shared { BasicSignupAPIService() }
    }

    private var emailCertificationService: EmailCertificationService {
        return shared { BasicEmailCertificationService() }
    }

    private var imageUploadService: ImageUploadService {
        return shared { BasicImageUploadService() }
    }

    private var randomNickNameGenerator: RandomNickNameGenerator {
        return shared { RandomNickNameGenerator() }
    }
}
