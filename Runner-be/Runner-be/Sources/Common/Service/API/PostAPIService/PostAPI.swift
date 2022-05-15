//
//  MainPageAPI.swift
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

    case myPage(userId: Int, token: LoginToken)
    case attendance(postId: Int, userId: Int, token: LoginToken)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case let .fetch(_, filter):
            return "/users/main/v2/\(filter.runningTag.code)"
        case let .posting(_, id, _):
            return "/postings/\(id)"
        case let .bookmarking(_, userId, mark, _):
            return "/users/\(userId)/bookmarks/\(mark ? "Y" : "N")"
        case let .fetchBookMarked(userId, _):
            return "/users/\(userId)/bookmarks/v2"
        case let .detail(postId, userId, _):
            return "/postings/\(postId)/\(userId)"
        case let .apply(postId, _, _):
            return "/runnings/request/\(postId)"
        case let .accept(postId, _, applicantId, accept, _):
            return "/runnings/request/\(postId)/handling/\(applicantId)/\(accept ? "Y" : "D")"
        case let .close(postId, _):
            return "/postings/\(postId)/closing"
        case let .myPage(userId, _):
            return "/users/\(userId)/myPage/v2"
        case let .attendance(postId, userId, _):
            return "/runnings/\(postId)/attendees/\(userId)"
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
        case .myPage:
            return Method.get
        case .attendance:
            return Method.patch
        }
    }

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
                "userLongitude": "\(filter.longitude)",
                "userLatitude": "\(filter.latitude)",
                "keywordSearch": filter.keywordSearch.isEmpty ? "N" : filter.keywordSearch,
            ]

            if let userId = userId {
                parameters["userId"] = userId
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .posting(form, _, _):
            let parameters: [String: Any] = [
                "title": form.title,
                "gatheringTime": form.gatheringTime,
                "runningTime": form.runningTime,
                "gatherLongitude": "\(form.gatherLongitude)",
                "gatherLatitude": "\(form.gatherLatitude)",
                "locationInfo": "\(form.locationInfo)",
                "runningTag": form.runningTag.code,
                "ageMin": "\(form.ageMin)",
                "ageMax": "\(form.ageMax)",
                "peopleNum": "\(form.peopleNum)",
                "contents": form.contents,
                "runnerGender": form.runnerGender.code,
            ]

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .bookmarking(postId, _, _, _):
            let query: [String: Any] = [
                "postId": postId,
            ]
            return .requestCompositeData(bodyData: Data(), urlParameters: query)
        case .fetchBookMarked:
            return .requestPlain
        case .detail:
            return .requestPlain
        case let .apply(_, userId, _):
            let query: [String: Any] = [
                "userId": userId,
            ]
            return .requestCompositeData(bodyData: Data(), urlParameters: query)
        case let .accept(_, userId, _, _, _):
            let query: [String: Any] = [
                "userId": userId,
            ]
            return .requestCompositeData(bodyData: Data(), urlParameters: query)
        case .close:
            return .requestPlain
        case .myPage:
            return .requestPlain
        case .attendance:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .fetch:
            return nil
        case let .posting(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .bookmarking(_, _, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .fetchBookMarked(_, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .detail(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .apply(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .accept(_, _, _, _, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .close(_, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .myPage(_, token):
            return ["x-access-token": "\(token.jwt)"]
        case let .attendance(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        }
    }
}
