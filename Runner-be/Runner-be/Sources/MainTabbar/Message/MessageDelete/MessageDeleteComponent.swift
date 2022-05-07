//
//  MessageDeleteComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/05/07.
//

import Foundation
import NeedleFoundation

protocol MessageDeleteDependency: Dependency {}

final class MessageDeleteComponent: Component<MessageDeleteDependency> {
//    lazy var scene: (VC: MessageDeleteViewController, VM: MessageDeleteViewModel) = (VC: MessageViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: MessageDeleteViewModel = .init()
}
