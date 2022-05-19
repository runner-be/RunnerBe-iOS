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

    // Message 화면에서 이동할 수 있는 모든 자식화면에 대한 컴포넌트 정의
    var messageDeleteComponent: MessageDeleteComponent {
        return MessageDeleteComponent(parent: self)
    }
}
