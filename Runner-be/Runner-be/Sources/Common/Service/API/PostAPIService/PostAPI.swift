//
//  PostAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import Moya

enum PostAPI {
    case fetch(userId: Int?, filter: PostFilter)
    case posting(form: PostingForm, id: Int, token: LoginToken)
    case bookmarking(postId: Int, userId: Int, mark: Bool, token: LoginToken)
    case fetchBookMarked(userId: Int, token: LoginToken)
    case detail(postId: Int, userId: Int, token: LoginToken)

    case apply(postId: Int, userId: Int, token: LoginToken)
    case accept(postId: Int, userId: Int, applicantId: Int, accept: Bool, token: LoginToken)
    case close(postId: Int, token: LoginToken)
    case delete(postId: Int, userId: Int, token: LoginToken)

    case myPage(userId: Int, token: LoginToken)
    case attendance(postId: Int, userId: Int, token: LoginToken)

    /// postings/:postId/report/:userId
    case report(postId: Int, userId: Int, token: LoginToken)
    case getRunnerList(userId: Int, token: LoginToken)
    case manageAttendance(postId: Int, request: PatchAttendanceRequest, token: LoginToken)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case .fetch:
            return "/users/main/v2"
        case let .posting(_, id, _):
            return "/postings/\(id)"
        case let .bookmarking(_, userId, mark, _):
            return "/users/\(userId)/bookmarks/\(mark ? "Y" : "N")"
        case let .fetchBookMarked(userId, _):
            return "/users/\(userId)/bookmarks/v2"
        case let .detail(postId, userId, _):
            return "/postings/v2/\(postId)/\(userId)"
        case let .apply(postId, userId, _):
            return "/runnings/request/\(postId)/\(userId)"
        case let .accept(postId, _, applicantId, accept, _):
            return "/runnings/request/\(postId)/handling/\(applicantId)/\(accept ? "Y" : "D")"
        case let .close(postId, _):
            return "/postings/\(postId)/closing"
        case let .delete(postId, userId, _):
            return "/postings/\(postId)/\(userId)/drop"
        case let .myPage(userId, _):
            return "/users/\(userId)/myPage/v2"
        case let .attendance(postId, userId, _):
            return "/runnings/\(postId)/attendees/\(userId)"
        case let .report(postId, userId, _):
            return "/postings/\(postId)/report/\(userId)"
        case let .manageAttendance(postId, _, _):
            return "/runnings/\(postId)/attend"
        case let .getRunnerList(userId, _):
            return "/users/\(userId)/myPage/v2"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetch:
            return Method.get
        case .posting:
            return Method.post
        case .bookmarking:
            return Method.post
        case .fetchBookMarked:
            return Method.get
        case .detail:
            return Method.get
        case .apply:
            return Method.post
        case .accept:
            return Method.patch
        case .close:
            return Method.post
        case .delete:
            return Method.patch
        case .myPage:
            return Method.get
        case .attendance:
            return Method.patch
        case .report:
            return Method.post
        case .manageAttendance:
            return Method.patch
        case .getRunnerList:
            return Method.get
        }
    }

    // TODO: 이후에 러닝페이스, 뒷풀이 필터, 페이징 추가 작업 시 수정필요
    var task: Task {
        switch self {
        case let .fetch(userId, filter):
            var parameters: [String: Any] = [
                "whetherEnd": filter.postState.code,
                "filter": filter.filter.code,
                "distanceFilter": "\(filter.distanceFilter)",
                "genderFilter": filter.gender.code,
                "ageFilterMax": "\(filter.ageMax)",
                "ageFilterMin": "\(filter.ageMin)",
                "jobFilter": filter.jobFilter.code,
                "paceFilter": filter.paceFilter.joined(separator: ","),
                "afterPartyFilter": "A",
                "userLongitude": "\(filter.longitude)",
                "userLatitude": "\(filter.latitude)",
                "keywordSearch": filter.keywordSearch.isEmpty ? "N" : filter.keywordSearch,
                "page": filter.page,
                "pageSize": filter.pageSize,
                "runningTag": filter.runningTag.code,
            ]

            if let userId = userId {
                parameters["userId"] = userId
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .posting(form, _, _):
            return .requestJSONEncodable(form)
        case let .bookmarking(postId, _, _, _):
            let query: [String: Any] = [
                "postId": postId,
            ]
            return .requestCompositeData(bodyData: Data(), urlParameters: query)
        case .fetchBookMarked:
            return .requestPlain
        case .detail:
            return .requestPlain
        case .apply:
            return .requestPlain
        case .accept:
            return .requestPlain
        case .close:
            return .requestPlain
        case .delete:
            return .requestPlain
        case .myPage:
            return .requestPlain
        case .attendance:
            return .requestPlain
        case .report:
            return .requestPlain
        case let .manageAttendance(_, request, _):
            let parameters: [String: Any] = [
                "userIdList": request.userIdList,
                "whetherAttendList": request.whetherAttendList,
            ]

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getRunnerList:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var header = ["MobileType": "iOS",
                      "AppVersion": AppContext.shared.version]
        switch self {
        case .fetch:
            return nil
        case let .posting(_, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .bookmarking(_, _, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .fetchBookMarked(_, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .detail(_, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .apply(_, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .accept(_, _, _, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .close(_, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .delete(_, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .myPage(_, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .attendance(_, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .report(_, _, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .manageAttendance(_, _, token):
            header["x-access-token"] = "\(token.jwt)"

        case let .getRunnerList(_, token):
            header["x-access-token"] = "\(token.jwt)"
        }
        return header
    }
}
