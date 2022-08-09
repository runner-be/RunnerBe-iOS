//
//  MessageComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import NeedleFoundation

protocol MessageDependency: Dependency {}

final class MessageComponent: Component<MessageDependency> {
    lazy var scene: (VC: MessageViewController, VM: MessageViewModel) = (VC: MessageViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: MessageViewModel = .init()

    func messageChatComponent(messageId: Int) -> MessageChatComponent {
        return MessageChatComponent(parent: self, messageId: messageId)
    }
}
