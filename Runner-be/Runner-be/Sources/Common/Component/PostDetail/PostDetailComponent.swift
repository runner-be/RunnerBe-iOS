//
//  PostDetailComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/25.
//

import UIKit

final class PostDetailComponent {
    var scene: (VC: UIViewController, VM: PostDetailViewModel) {
        let viewModel = self.viewModel
        return (PostDetailViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: PostDetailViewModel {
        return PostDetailViewModel(postId: postId)
    }

    let fromMessageChat: Bool
    let postId: Int

    /* component 생성시 추가 정보가 필요하다면 다음처럼 init을 구현해주시면 됩니다. */
    init(postId: Int, fromMessageChat: Bool = false) {
        self.postId = postId
        self.fromMessageChat = fromMessageChat
    }

    func applicantListModal(applicants: [User]) -> ApplicantListModalComponent {
        return ApplicantListModalComponent(postId: postId, applicants: applicants)
    }

    func messageChatComponent(roomID: Int) -> MessageChatComponent {
        return MessageChatComponent(messageId: roomID, fromPostDetail: true)
    }

    var reportModalComponent: ReportModalComponent {
        return ReportModalComponent()
    }

    var detailOptionModalComponent: DetailOptionModalComponent {
        return DetailOptionModalComponent()
    }

    var deleteConfirmModalComponent: DeleteConfirmModalComponent {
        return DeleteConfirmModalComponent()
    }
}
