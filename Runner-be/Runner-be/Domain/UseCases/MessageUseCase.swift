//
//  MessageUseCase.swift
//  Runner-be
//
//  Created by 이유리 on 2023/08/25.
//

import Foundation
import RxSwift

final class MessageUseCase {
    private var messageAPIRepo: MessageAPIService = BasicMessageAPIService()

    // MARK: - Network

    func getMessageRoomList() -> Observable<APIResult<[MessageRoom]?>> {
        return messageAPIRepo.getMessageRoomList()
    }

    func getMessageContents(roomId: Int) -> Observable<APIResult<GetMessageRoomInfoResult?>> {
        return messageAPIRepo.getMessageContents(roomId: roomId)
    }

    func postMessage(roomId: Int, content: String) -> Observable<APIResult<Bool>> {
        return messageAPIRepo.postMessage(roomId: roomId, content: content)
    }

    func reportMessages(reportMessageIndexString: String) -> Observable<APIResult<Bool>> {
        return messageAPIRepo.reportMessages(reportMessageIndexString: reportMessageIndexString)
    }
}
