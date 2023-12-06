//
//  BookMarkComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

final class BookMarkComponent {
    lazy var scene: (VC: BookMarkViewController, VM: BookMarkViewModel) = (VC: BookMarkViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = BookMarkViewModel()

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId)
    }
}
