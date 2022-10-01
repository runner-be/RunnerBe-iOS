//
//  WritingDetailPostComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import UIKit

final class WritingDetailPostComponent {
    var scene: (VC: UIViewController, VM: WritingDetailPostViewModel) {
        let viewModel = self.viewModel
        return (WritingDetailPostViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WritingDetailPostViewModel {
        return WritingDetailPostViewModel(writingPostData: writingPostData)
    }

    init(writingPostData: WritingPostData) {
        self.writingPostData = writingPostData
    }

    var writingPostData: WritingPostData
}
