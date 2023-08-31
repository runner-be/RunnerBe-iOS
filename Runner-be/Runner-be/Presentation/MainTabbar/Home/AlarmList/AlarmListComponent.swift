//
//  AlarmListComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/08/21.
//

import UIKit

final class AlarmListComponent {
    var scene: (VC: UIViewController, VM: AlarmListViewModel) {
        let viewModel = self.viewModel
        return (AlarmListViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: AlarmListViewModel {
        return AlarmListViewModel()
    }
}
