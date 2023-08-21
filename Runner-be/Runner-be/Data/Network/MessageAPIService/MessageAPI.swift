//
//  MessageAPI.swift
//  Runner-be
//
//  Created by 이유리 on 2023/01/18.
//

import Foundation
import Moya

enum MessageAPI {
    case getMessageList(token: LoginToken)
    case getMessageRoomContents(roomId: Int, token: LoginToken)
    case postMessage(roomId: Int, postMessageRequest: PostMessageRequest, token: LoginToken)
    case reportMessage(token: LoginToken, postReportMessageRequest: PostMessageReportRequest)
}

extension MessageAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case .getMessageList:
            return "/messages"
        case let .getMessageRoomContents(roomId, _):
            return "/messages/rooms/\(roomId)"
        case let .postMessage(roomId, _, _):
            return "/messages/rooms/\(roomId)"
        case .reportMessage:
            return "/messages/report"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMessageList:
            return Method.get
        case .getMessageRoomContents:
            return Method.get
        case .postMessage:
            return Method.post
        case .reportMessage:
            return Method.post
        }
    }

    var task: Task {
        switch self {
        case .getMessageList:
            return .requestPlain
        case .getMessageRoomContents:
            return .requestPlain
        case let .postMessage(_, postMessageRequest, _):
            return .requestJSONEncodable(postMessageRequest)
        case let .reportMessage(_, postReportMessageRequest):
            return .requestJSONEncodable(postReportMessageRequest)
        }
    }

    var headers: [String: String]? {
        var header = ["MobileType": "iOS",
                      "AppVersion": AppContext.shared.version]
        switch self {
        case let .getMessageList(token):
            header["x-access-token"] = "\(token.jwt)"
        case let .getMessageRoomContents(roomId: _, token: token):
            header["x-access-token"] = "\(token.jwt)"
        case let .postMessage(roomId: _, postMessageRequest: _, token: token):
            header["x-access-token"] = "\(token.jwt)"
        case let .reportMessage(token, _):
            header["x-access-token"] = "\(token.jwt)"
        }
        return header
    }
}
