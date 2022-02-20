//
//  WritingDetailPostComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import Foundation
import NeedleFoundation

protocol WritingDetailPostDependency: Dependency {}

final class WritingDetailPostComponent: Component<WritingDetailPostDependency> {
    var scene: (VC: UIViewController, VM: WritingDetailPostViewModel) {
        let viewModel = self.viewModel
        return (WritingDetailPostViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WritingDetailPostViewModel {
        return WritingDetailPostViewModel()
    }
}
