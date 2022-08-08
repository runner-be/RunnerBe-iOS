//
//  PostDetailComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import NeedleFoundation

protocol PostDetailDependency: Dependency {}

final class PostDetailComponent: Component<PostDetailDependency> {
    var scene: (VC: UIViewController, VM: PostDetailViewModel) {
        let viewModel = self.viewModel
        return (PostDetailViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: PostDetailViewModel {
        return PostDetailViewModel(postId: postId)
    }

    let postId: Int

    init(parent: Scope, postId: Int) {
        self.postId = postId
        super.init(parent: parent)
    }

    func applicantListModal(applicants: [User]) -> ApplicantListModalComponent {
        return ApplicantListModalComponent(parent: self, postId: postId, applicants: applicants)
    }

    var reportModalComponent: ReportModalComponent {
        return ReportModalComponent(parent: self)
    }

    var detailOptionModalComponent: DetailOptionModalComponent {
        return DetailOptionModalComponent(parent: self)
    }

    var deleteConfirmModalComponent: DeleteConfirmModalComponent {
        return DeleteConfirmModalComponent(parent: self)
    }
}
