//
//  HomeFilterComponent.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/16.
//

import UIKit

final class HomeFilterComponent {
    var scene: (VC: UIViewController, VM: HomeFilterViewModel) {
        let viewModel = self.viewModel
        return (HomeFilterViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: HomeFilterViewModel {
        return HomeFilterViewModel(inputFilter: inputFilter)
    }

    init(filter: PostFilter) {
        inputFilter = filter
    }

    private var inputFilter: PostFilter
}
