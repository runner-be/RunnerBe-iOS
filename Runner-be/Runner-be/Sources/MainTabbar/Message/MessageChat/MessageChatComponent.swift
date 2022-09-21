//
//  MessageComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import UIKit

final class MessageChatComponent {
    var scene: (VC: UIViewController, VM: MessageChatViewModel) {
        let viewModel = self.viewModel
        return (MessageChatViewController(viewModel: viewModel, messageId: messageId), viewModel)
    }

    var viewModel: MessageChatViewModel {
        MessageChatViewModel(messageId: messageId)
    }

    init(messageId: Int) {
        self.messageId = messageId
    }

    var messageId: Int

    func reportMessageComponent(messageId: Int) -> MessageReportComponent {
        return MessageReportComponent(messageId: messageId)
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId)
    }
}
