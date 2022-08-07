//
//  MessageDataManager.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/20.
//

import Alamofire
import Foundation

class MessageDataManager {
    func getMessageList(viewController: MessageViewController) {
        AF.request("\(Constant.BASE_URL)messages", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GetMessageListResponse.self) { response in
                switch response.result {
                case let .success(response):
                    print(response)
                    if response.isSuccess {
                        viewController.didSucessGetMessageList(response.result!)
                    } else {
                        viewController.failedToRequest(message: response.message)
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }

    func getMessageChat(viewController: MessageChatViewController, roomId: Int) {
        AF.request("\(Constant.BASE_URL)messages/rooms/\(roomId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GetMessageChatResponse.self) { response in
                switch response.result {
                case let .success(response):
                    print(response)
                    if response.isSuccess {
                        viewController.didSucessGetMessageChat(response.result!)
                    } else {
                        viewController.failedToRequest(message: response.message)
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
