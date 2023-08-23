//
//  MessageAPIService.swift
//  Runner-be
//
//  Created by 이유리 on 2023/08/22.
//

import Foundation
import RxSwift

protocol MessageAPIService {
    func getMessageRoomList() -> Observable<APIResult<[MessageRoom]?>>
    func getMessageContents(roomId: Int) -> Observable<APIResult<GetMessageRoomInfoResult?>>
    func postMessage(roomId: Int, content: String) -> Observable<APIResult<Bool>>
    func reportMessages(reportMessageIndexString: String) -> Observable<APIResult<Bool>>
}
