//
//  WritingPostComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import UIKit

final class WritingMainPostComponent {
    var scene: (VC: UIViewController, VM: WritingMainPostViewModel) {
        let viewModel = self.viewModel
        return (WritingMainPostViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WritingMainPostViewModel {
        return WritingMainPostViewModel()
    }

    var selectTimeComponent: SelectTimeModalComponent {
        return SelectTimeModalComponent()
    }

    var selectDateComponent: SelectDateModalComponent {
        return SelectDateModalComponent()
    }

    func BuildWritingDetailPostComponent(with data: WritingPostData) -> WritingDetailPostComponent {
        return WritingDetailPostComponent(writingPostData: data)
    }
}
