//
//  2__2MessageComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MessageDependency: Dependency {}

final class MessageComponent: Component<MessageDependency> {
    var scene: (VC: MessageViewController, VM: MessageViewModel) {
        return shared {
            let viewModel = viewModel
            return (VC: MessageViewController(viewModel: viewModel), VM: viewModel)
        }
    }

    var viewModel: MessageViewModel {
        return MessageViewModel()
    }
}
