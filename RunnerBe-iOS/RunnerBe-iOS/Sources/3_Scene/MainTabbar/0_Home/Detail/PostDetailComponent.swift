//
//  PostDetailComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import NeedleFoundation

protocol PostDetailDependency: Dependency {}

final class PostDetailComponent: Component<PostDetailDependency> {
    var scene: (VC: UIViewController, VM: PostDetailViewModel) {
        let viewModel = self.viewModel
        return (PostDetailViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: PostDetailViewModel {
        return PostDetailViewModel()
    }
}
