//
//  2__1BookMarkComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol BookMarkDependency: Dependency {}

final class BookMarkComponent: Component<BookMarkDependency> {
    lazy var scene: (VC: BookMarkViewController, VM: BookMarkViewModel) = (VC: BookMarkViewController(viewModel: viewModel), VM: viewModel)

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(parent: self, postId: postId)
    }

    lazy var viewModel = BookMarkViewModel()
}
