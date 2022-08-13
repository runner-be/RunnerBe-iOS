//
//  MessageReportComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import Foundation
import NeedleFoundation

protocol MessageReportDependency: Dependency {}

final class MessageReportComponent: Component<MessageReportDependency> {
    var scene: (VC: UIViewController, VM: MessageReportViewModel) {
        let viewModel = self.viewModel
        return (MessageReportViewController(viewModel: viewModel, messageId: messageId), viewModel)
    }

    var viewModel: MessageReportViewModel {
        MessageReportViewModel(messageId: messageId)
    }

    init(parent: Scope, messageId: Int) {
        self.messageId = messageId
        super.init(parent: parent)
    }

    var messageId: Int

    var reportModalComponent: ReportModalComponent {
        return ReportModalComponent(parent: self)
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(parent: self, postId: postId)
    }
}
