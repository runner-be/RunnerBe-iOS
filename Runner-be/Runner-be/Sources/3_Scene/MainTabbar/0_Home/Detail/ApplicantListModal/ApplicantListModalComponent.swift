//
//  ApplicantListModalComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import Foundation
import NeedleFoundation

protocol ApplicantListModalDependency: Dependency {}

final class ApplicantListModalComponent: Component<ApplicantListModalDependency> {
    var scene: (VC: UIViewController, VM: ApplicantListModalViewModel) {
        let viewModel = self.viewModel
        return (ApplicantListModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: ApplicantListModalViewModel {
        return ApplicantListModalViewModel(postId: postId, applicants: applicants)
    }

    let applicants: [User]
    let postId: Int

    init(parent: Scope, postId: Int, applicants: [User]) {
        self.applicants = applicants
        self.postId = postId
        super.init(parent: parent)
    }
}
