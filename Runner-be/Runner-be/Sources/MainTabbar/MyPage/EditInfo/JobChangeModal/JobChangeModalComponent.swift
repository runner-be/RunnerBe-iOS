//
//  JobChangeModalComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/23.
//

import UIKit

final class JobChangeModalComponent {
    var scene: (VC: UIViewController, VM: JobChangeModalViewModel) {
        let viewModel = self.viewModel
        return (JobChangeModalViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: JobChangeModalViewModel {
        return JobChangeModalViewModel()
    }
}
