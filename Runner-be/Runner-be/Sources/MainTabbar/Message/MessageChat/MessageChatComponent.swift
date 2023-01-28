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
        return (MessageChatViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: MessageChatViewModel {
        MessageChatViewModel(roomId: roomId)
    }

    init(roomId: Int, fromPostDetail: Bool = false) {
        self.roomId = roomId
        self.fromPostDetail = fromPostDetail
    }

    var roomId: Int
    var fromPostDetail: Bool

    func reportMessageComponent(messageId: Int) -> MessageReportComponent {
        return MessageReportComponent(messageId: messageId)
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId, fromMessageChat: true)
    }
}
