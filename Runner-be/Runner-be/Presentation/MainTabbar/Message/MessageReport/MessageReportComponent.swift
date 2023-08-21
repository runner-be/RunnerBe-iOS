//
//  MessageReportComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import UIKit

final class MessageReportComponent {
    var scene: (VC: UIViewController, VM: MessageReportViewModel) {
        let viewModel = self.viewModel
        return (MessageReportViewController(viewModel: viewModel, roomId: roomId), viewModel)
    }

    var viewModel: MessageReportViewModel {
        MessageReportViewModel(roomId: roomId)
    }

    init(roomId: Int) {
        self.roomId = roomId
    }

    var roomId: Int

    var reportModalComponent: ReportModalComponent {
        return ReportModalComponent()
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId)
    }
}
