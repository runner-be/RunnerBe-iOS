//
//  ConfirmAttendanceComponent.swift
//  Runner-be
//
//  Created by 김창규 on 9/1/24.
//

import UIKit

final class ConfirmAttendanceComponent {
    var scene: (VC: UIViewController, VM: ConfirmAttendanceViewModel) {
        let viewModel = self.viewModel
        return (ConfirmAttendanceViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: ConfirmAttendanceViewModel {
        return ConfirmAttendanceViewModel(postId: postId)
    }

    let postId: Int

    init(postId: Int) {
        self.postId = postId
    }
}
