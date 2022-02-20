//
//  WritingPostComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import Foundation
import NeedleFoundation

protocol WritingPostDependency: Dependency {}

final class WritingPostComponent: Component<WritingPostDependency> {
    var scene: (VC: UIViewController, VM: WritingPostViewModel) {
        let viewModel = self.viewModel
        return (WritingPostViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WritingPostViewModel {
        return WritingPostViewModel()
    }

    var selectTimeComponent: SelectTimeModalComponent {
        return SelectTimeModalComponent(parent: self)
    }

    var selectDateComponent: SelectDateModalComponent {
        return SelectDateModalComponent(parent: self)
    }
}
