//
//  WritingDetailPostComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/21.
//

import Foundation
import NeedleFoundation

protocol WritingDetailPostDependency: Dependency {
    var postAPIService: PostAPIService { get }
    var dateService: DateService { get }
    var loginService: LoginService { get }
}

final class WritingDetailPostComponent: Component<WritingDetailPostDependency> {
    var scene: (VC: UIViewController, VM: WritingDetailPostViewModel) {
        let viewModel = self.viewModel
        return (WritingDetailPostViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WritingDetailPostViewModel {
        return WritingDetailPostViewModel(mainPostData: postMainData, postAPIService: dependency.postAPIService, dateService: dependency.dateService)
    }

    init(parent: Scope, postMainData: PostMainData) {
        self.postMainData = postMainData
        super.init(parent: parent)
    }

    var postMainData: PostMainData
}
