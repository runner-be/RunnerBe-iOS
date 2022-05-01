//
//  HomeFilterComponent.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import Foundation
import NeedleFoundation

protocol HomeFilterDependency: Dependency {}

final class HomeFilterComponent: Component<HomeFilterDependency> {
    var scene: (VC: UIViewController, VM: HomeFilterViewModel) {
        let viewModel = self.viewModel
        return (HomeFilterViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: HomeFilterViewModel {
        return HomeFilterViewModel(inputFilter: inputFilter)
    }

    init(_ parent: Scope, filter: PostFilter) {
        inputFilter = filter
        super.init(parent: parent)
    }

    private var inputFilter: PostFilter
}
