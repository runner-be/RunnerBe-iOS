//
//  WritingPostComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import Foundation
import NeedleFoundation

protocol WritingMainPostDependency: Dependency {}

final class WritingMainPostComponent: Component<WritingMainPostDependency> {
    var scene: (VC: UIViewController, VM: WritingMainPostViewModel) {
        let viewModel = self.viewModel
        return (WritingMainPostViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WritingMainPostViewModel {
        return WritingMainPostViewModel()
    }

    var selectTimeComponent: SelectTimeModalComponent {
        return SelectTimeModalComponent(parent: self)
    }

    var selectDateComponent: SelectDateModalComponent {
        return SelectDateModalComponent(parent: self)
    }

    func BuildWritingDetailPostComponent(with data: WritingPostDetailConfigData) -> WritingDetailPostComponent {
        return WritingDetailPostComponent(parent: self, postMainData: data)
    }
}