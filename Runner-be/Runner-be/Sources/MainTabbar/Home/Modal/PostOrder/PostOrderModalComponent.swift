//
//  PostOrderComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/07/27.
//

import Foundation
import NeedleFoundation

protocol PostOrderModalDependency: Dependency {}

final class PostOrderModalComponent: Component<PostOrderModalDependency> {
    var scene: (VC: UIViewController, VM: PostOrderModalViewModel) {
        let viewModel = self.viewModel
        return (PostOrderModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: PostOrderModalViewModel {
        return PostOrderModalViewModel()
    }
}
