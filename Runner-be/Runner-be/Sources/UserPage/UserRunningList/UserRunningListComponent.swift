//
//  UserRunningListComponent.swift
//  Runner-be
//
//  Created by 김창규 on 10/22/24.
//

import Foundation
import UIKit

final class UserRunningListComponent {
    var scene: (VC: UIViewController, VM: UserRunningListViewModel) {
        let viewModel = self.viewModel
        return (UserRunningListViewController(viewModel: viewModel), viewModel)
    }

    let userId: Int

    var viewModel: UserRunningListViewModel {
        return UserRunningListViewModel(userId: userId)
    }

    init(userId: Int) {
        self.userId = userId
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId)
    }
}
