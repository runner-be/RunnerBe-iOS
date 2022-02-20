//
//  2__2MessageListComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MessageListDependency: Dependency {}

final class MessageListComponent: Component<MessageListDependency> {
    var scene: (VC: MessageListViewController, VM: MessageListViewModel) {
        return shared {
            let viewModel = viewModel
            return (VC: MessageListViewController(viewModel: viewModel), VM: viewModel)
        }
    }

    var viewModel: MessageListViewModel {
        return MessageListViewModel()
    }
}
