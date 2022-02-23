//
//  MainPageAPI.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/23.
//

import Foundation
import Moya

enum MainPageAPI {
    case fetch(filter: PostFilter)
    case posting(form: PostingForm, id: Int, token: LoginToken)
}

extension MainPageAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case let .fetch(filter):
            return "/users/main/\(filter.runningTag.code)"
        case let .posting(_, id, _):
            return "/postings/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetch:
            return Method.get
        case .posting:
            return Method.post
        }
    }

    var task: Task {
        switch self {
        case let .fetch(filter):
            let body: [String: Any] = [
                "userLongitude": "\(filter.longitude)",
                "userLatitude": "\(filter.latitude)",
            ]

            let query: [String: Any] = [
                "whetherEnd": filter.wheterEnd.code,
                "filter": filter.filter.code,
                "distanceFilter": "\(filter.distanceFilter)",
                "genderFilter": filter.gender.code,
                "ageFilterMax": "\(filter.ageMax)",
                "ageFilterMin": "\(filter.ageMin)",
            ]

            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: query)
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
        }
    }

    var headers: [String: String]? {
        switch self {
        case .fetch:
            return nil
        case let .posting(_, _, token):
            return ["x-access-token": "\(token.jwt)"]
        }
    }
}
