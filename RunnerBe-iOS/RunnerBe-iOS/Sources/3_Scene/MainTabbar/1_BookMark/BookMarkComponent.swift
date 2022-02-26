//
//  2__1BookMarkComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol BookMarkDependency: Dependency {
    var postAPIService: PostAPIService { get }
}

final class BookMarkComponent: Component<BookMarkDependency> {
    var sharedScene: (VC: BookMarkViewController, VM: BookMarkViewModel) {
        return shared {
            let viewModel = viewModel
            return (VC: BookMarkViewController(viewModel: viewModel), VM: viewModel)
        }
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(parent: self, postId: postId)
    }

    var viewModel: BookMarkViewModel {
        return BookMarkViewModel(postAPIService: dependency.postAPIService)
    }
}
