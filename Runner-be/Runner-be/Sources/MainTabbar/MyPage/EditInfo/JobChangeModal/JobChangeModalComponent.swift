//
//  JobChangeModal.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//

import Foundation
import NeedleFoundation

protocol JobChangeModalDependency: Dependency {}

final class JobChangeModalComponent: Component<JobChangeModalDependency> {
    var scene: (VC: UIViewController, VM: JobChangeModalViewModel) {
        let viewModel = self.viewModel
        return (JobChangeModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: JobChangeModalViewModel {
        return JobChangeModalViewModel()
    }
}
