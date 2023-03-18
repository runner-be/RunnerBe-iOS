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
        AF.request("\(Constant.BASE_URL)messages", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: UserInfo().headers)
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

    func getMessageChat(viewController: MessageRoomViewController, roomId: Int) {
        AF.request("\(Constant.BASE_URL)messages/rooms/\(roomId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: UserInfo().headers)
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

    func getMessageChat(viewController: MessageReportViewController, roomId: Int) {
        AF.request("\(Constant.BASE_URL)messages/rooms/\(roomId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: UserInfo().headers)
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

    func postMessage(viewController: MessageRoomViewController, roomId: Int, content: String) {
        let parameters = PostMessageRequest(content: content)
        AF.request("\(Constant.BASE_URL)messages/rooms/\(roomId)", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: UserInfo().headers)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        viewController.didSuccessPostMessage(response)

                    } else {
                        viewController.failedToRequest(message: response.message)
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }

    func reportMessage(viewController: MessageReportViewController, messageIdList: String) {
        let parameters = PostMessageReportRequest(messageIdList: messageIdList)
        AF.request("\(Constant.BASE_URL)messages/report", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: UserInfo().headers)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        viewController.didSuccessReportMessage(response)

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
