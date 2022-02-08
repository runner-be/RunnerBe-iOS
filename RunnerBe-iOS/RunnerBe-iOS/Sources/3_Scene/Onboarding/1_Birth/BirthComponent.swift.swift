//
//  BirthComponent.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/07.
//

import Foundation

import Foundation
import NeedleFoundation

protocol BirthDependency: Dependency {}

final class BirthComponent: Component<BirthDependency> {
    var birthViewController: UIViewController {
        return BirthViewController(viewModel: birthViewModel)
    }

    var birthViewModel: BirthViewModel {
        return shared { BirthViewModel() }
    }

    var selectGenderComponent: SelectGenderComponent {
        return SelectGenderComponent(parent: self)
    }
}
