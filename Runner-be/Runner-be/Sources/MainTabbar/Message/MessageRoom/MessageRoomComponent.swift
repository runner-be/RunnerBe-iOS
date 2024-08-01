//
//  MessageRoomComponent.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import UIKit

final class MessageRoomComponent {
    var scene: (VC: UIViewController, VM: MessageRoomViewModel) {
        let viewModel = self.viewModel
        return (MessageRoomViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: MessageRoomViewModel {
        MessageRoomViewModel(roomId: roomId)
    }

    var roomId: Int
    var fromPostDetail: Bool

    init(roomId: Int, fromPostDetail: Bool = false) {
        self.roomId = roomId
        self.fromPostDetail = fromPostDetail
    }

    var takePhotoModalComponent: TakePhotoModalComponent {
        return TakePhotoModalComponent(isShowBasicImageOption: false)
    }

    func reportMessageComponent(roomId: Int) -> MessageReportComponent {
        return MessageReportComponent(roomId: roomId)
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId, fromMessageRoom: true)
    }

    func imageViewerComponent(image: UIImage) -> ImageViewerComponent {
        return ImageViewerComponent(image: image)
    }
}
