//
//  PostDetailComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import Foundation
import NeedleFoundation

protocol PostDetailDependency: Dependency {
    var postAPIService: PostAPIService { get }
    var userKeyChainService: UserKeychainService { get }
}

final class PostDetailComponent: Component<PostDetailDependency> {
    var scene: (VC: UIViewController, VM: PostDetailViewModel) {
        let viewModel = self.viewModel
        return (PostDetailViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: PostDetailViewModel {
        return PostDetailViewModel(postId: postId, postAPIService: dependency.postAPIService, userKeyChainService: dependency.userKeyChainService)
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
}
