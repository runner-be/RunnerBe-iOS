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

    init(messageId: Int, fromPostDetail: Bool = false) {
        self.messageId = messageId
        self.fromPostDetail = fromPostDetail
    }

    var messageId: Int
    var fromPostDetail: Bool

    func reportMessageComponent(messageId: Int) -> MessageReportComponent {
        return MessageReportComponent(messageId: messageId)
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId, fromMessageChat: true)
    }
}
