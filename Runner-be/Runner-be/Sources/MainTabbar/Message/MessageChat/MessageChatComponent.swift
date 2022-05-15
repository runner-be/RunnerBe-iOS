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
    lazy var scene: (VC: MessageChatViewController, VM: MessageChatViewModel) = (VC: MessageChatViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: MessageChatViewModel = .init()

    var reportModalComponent: ReportModalComponent {
        return ReportModalComponent(parent: self)
    }
}
