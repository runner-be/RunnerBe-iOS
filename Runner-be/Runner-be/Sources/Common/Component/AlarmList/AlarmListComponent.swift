//
//  AlarmListComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import Foundation
import NeedleFoundation

protocol AlarmListDependency: Dependency {}

final class AlarmListComponent: Component<AlarmListDependency> {
    var scene: (VC: UIViewController, VM: AlarmListViewModel) {
        let viewModel = self.viewModel
        return (AlarmListViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: AlarmListViewModel {
        return AlarmListViewModel()
    }
}
