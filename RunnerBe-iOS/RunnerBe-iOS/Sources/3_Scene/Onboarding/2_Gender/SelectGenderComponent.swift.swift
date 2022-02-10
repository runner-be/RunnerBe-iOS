//
//  SelectGenderComponent.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import Foundation
import NeedleFoundation

protocol SelectGenderDependency: Dependency {}

final class SelectGenderComponent: Component<SelectGenderDependency> {
    var selectGenderViewController: UIViewController {
        return SelectGenderViewController(viewModel: selectGenderViewModel)
    }

    var selectGenderViewModel: SelectGenderViewModel {
        return shared { SelectGenderViewModel() }
    }

    var selectJobGroupCoord: SelectJobGroupComponent {
        return SelectJobGroupComponent(parent: self)
    }

    var onboardingCancelModalComponent: OnboardingCancelModalComponent {
        return OnboardingCancelModalComponent(parent: self)
    }
}
