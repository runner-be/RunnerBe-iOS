//
//  ConfirmLogComponent.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import Foundation

final class ConfirmLogComponent {
    var scene: (VC: ConfirmLogViewController, VM: ConfirmLogViewModel) {
        let viewModel = self.viewModel
        return (VC: ConfirmLogViewController(viewModel: viewModel), VM: viewModel)
    }

    var viewModel: ConfirmLogViewModel {
        return ConfirmLogViewModel(postId: postId)
    }

    var postId: Int

    init(postId: Int) {
        self.postId = postId
    }
}
