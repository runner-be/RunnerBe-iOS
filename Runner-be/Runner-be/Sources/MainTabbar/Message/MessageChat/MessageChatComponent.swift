//
//  MessageComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import NeedleFoundation

protocol MessageChatDependency: Dependency {}

final class MessageChatComponent: Component<MessageChatDependency> {
    var scene: (VC: UIViewController, VM: MessageChatViewModel) {
        let viewModel = self.viewModel
        return (MessageChatViewController(viewModel: viewModel, messageId: messageId), viewModel)
    }

    var viewModel: MessageChatViewModel {
        MessageChatViewModel(messageId: messageId)
    }

    init(parent: Scope, messageId: Int) {
        self.messageId = messageId
        super.init(parent: parent)
    }

    var messageId: Int

    var reportModalComponent: ReportModalComponent {
        return ReportModalComponent(parent: self)
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(parent: self, postId: postId)
    }
}
