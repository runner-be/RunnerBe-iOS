//
//  PostDetailComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import NeedleFoundation

protocol PostDetailDependency: Dependency {
    var postAPIService: PostAPIService { get }
}

final class PostDetailComponent: Component<PostDetailDependency> {
    var scene: (VC: UIViewController, VM: PostDetailViewModel) {
        let viewModel = self.viewModel
        return (PostDetailViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: PostDetailViewModel {
        return PostDetailViewModel(postId: postId, postAPIService: dependency.postAPIService)
    }

    let postId: Int

    init(parent: Scope, postId: Int) {
        self.postId = postId
        super.init(parent: parent)
    }
}
