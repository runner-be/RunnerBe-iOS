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
        return (JobChangeModalViewController(viewModel: viewModel, job: job), viewModel)
    }

    let job: String

    /* component 생성시 추가 정보가 필요하다면 다음처럼 init을 구현해주시면 됩니다. */
    init(parent: Scope, job: String) {
        self.job = job
        super.init(parent: parent)
    }

    var viewModel: JobChangeModalViewModel {
        return JobChangeModalViewModel(job: job)
    }
}
