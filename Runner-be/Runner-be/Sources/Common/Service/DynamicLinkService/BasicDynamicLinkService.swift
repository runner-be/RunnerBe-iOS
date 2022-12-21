//
//  BasicDynamicLinkService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/14.
//

import Firebase
import Foundation
import RxSwift

final class BasicDynamicLinkService: DynamicLinkService {
    func generateLink(resultPath: String, parameters: [String: String]) -> Observable<URL?> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = DynamicLinkElement.host
        components.path = "/\(resultPath)" // to show page

        components.queryItems = parameters.reduce(into: [URLQueryItem]()) { partialResult, keyValue in
            partialResult?.append(URLQueryItem(name: keyValue.key, value: keyValue.value))
        }
        guard let linkParameter = components.url else { return .just(nil) }

        let domain = DynamicLinkElement.domain
        guard let linkBuilder = DynamicLinkComponents(link: linkParameter, domainURIPrefix: domain)
        else { return .just(nil) }

        if let myBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }

        linkBuilder.iOSParameters?.appStoreID = DynamicLinkElement.appStoreID

        guard let longURL = linkBuilder.url else { return .just(nil) }
        let urlSubject = ReplaySubject<URL?>.create(bufferSize: 1)

        linkBuilder.shorten { url, warnings, error in
            if error != nil {
                urlSubject.onNext(longURL)
                return
            }

            if let warnings = warnings {
                for warning in warnings {
                    Log.d(tag: .warning, "Warning: \(warning)")
                }
            }

            guard let url = url else { return }
            urlSubject.onNext(url)
        }

        return urlSubject.take(1)
    }
}
