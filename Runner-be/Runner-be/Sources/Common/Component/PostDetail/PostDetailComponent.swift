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

    /* component 생성시 추가 정보가 필요하다면 다음처럼 init을 구현해주시면 됩니다. */
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
}
