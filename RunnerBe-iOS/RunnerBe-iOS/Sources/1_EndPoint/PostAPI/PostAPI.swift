//
//  MainPageAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import Moya

enum PostAPI {
    case fetch(filter: PostFilter)
    case posting(form: PostingForm, id: Int, token: LoginToken)
    case bookmarking(postId: Int, userId: Int, mark: Bool, token: LoginToken)
    case fetchBookMarked(userId: Int, token: LoginToken)
    case detail(postId: Int, userId: Int, token: LoginToken)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case let .fetch(filter):
            return "/users/main/\(filter.runningTag.code)"
        case let .posting(_, id, _):
            return "/postings/\(id)"
        case let .bookmarking(_, userId, mark, _):
            return "/users/\(userId)/bookmarks/\(mark ? "Y" : "N")"
        case let .fetchBookMarked(userId, _):
            return "/users/\(userId)/bookmarks"
        case let .detail(postId, userId, _):
            return "/postings/\(postId)/\(userId)"
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
        }
    }

    var task: Task {
        switch self {
        case let .fetch(filter):
            let parameters: [String: Any] = [
                "userLongitude": "\(filter.longitude)",
                "userLatitude": "\(filter.latitude)",
                "whetherEnd": filter.wheterEnd.code,
                "filter": filter.filter.code,
                "distanceFilter": "\(filter.distanceFilter)",
                "genderFilter": filter.gender.code,
                "ageFilterMax": "\(filter.ageMax)",
                "ageFilterMin": "\(filter.ageMin)",
                "jobFilter": filter.jobFilter.code,
                "keywordSearch": filter.keywordSearch.isEmpty ? "N" : filter.keywordSearch,
            ]

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
        }
    }
}
