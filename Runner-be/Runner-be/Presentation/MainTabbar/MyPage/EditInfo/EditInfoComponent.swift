//
//  EditInfoComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import UIKit

final class EditInfoComponent {
    var scene: (VC: UIViewController, VM: EditInfoViewModel) {
        let viewModel = self.viewModel
        return (EditInfoViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: EditInfoViewModel {
        return EditInfoViewModel(user: user)
    }

    init(user: User) {
        self.user = user
    }

    var user: User

    var nickNameModalComponent: NickNameChangeModalComponent {
        return NickNameChangeModalComponent()
    }

    var jobChangeModalComponent: JobChangeModalComponent {
        return JobChangeModalComponent()
    }
}
