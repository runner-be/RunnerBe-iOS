//
//  MessageComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import UIKit

final class MessageComponent {
    lazy var scene: (VC: MessageViewController, VM: MessageViewModel) = (VC: MessageViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: MessageViewModel = .init()

    func messageChatComponent(roomId: Int) -> MessageChatComponent {
        return MessageChatComponent(roomId: roomId)
    }
}
