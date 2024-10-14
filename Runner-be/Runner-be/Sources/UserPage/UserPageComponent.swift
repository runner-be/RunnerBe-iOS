//
//  UserPageComponent.swift
//  Runner-be
//
//  Created by 김창규 on 10/14/24.
//

import UIKit

final class UserPageComponent {
    var scene: (VC: UIViewController, VM: UserPageViewModel) {
        let viewModel = self.viewModel
        return (UserPageViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: UserPageViewModel {
        return UserPageViewModel(userId: userId)
    }

    let userId: Int

    init(userId: Int) {
        self.userId = userId
    }
}
