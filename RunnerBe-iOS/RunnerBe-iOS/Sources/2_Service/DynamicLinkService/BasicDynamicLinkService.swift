//
//  BasicDynamicLinkService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/14.
//

import Firebase
import Foundation

final class BasicDynamicLinkService: DynamicLinkService {
    func generateLink() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "" // host
        components.path = "" // to show page

        // to find a specific recipe on website or in the app
        //        let itemIDQueryItem = URLQueryItem(name: "recipeID", value: "abcd")
        //        components.queryItems = [itemIDQueryItem]

        guard let linkParameter = components.url else { return }

        // defines a dynamic link component object with the URL you defined previously
        // and the URI prefix, which is what you defined in the Firebase console
        // under dynamic links: https://[your domain].
        // TODO: replace with your own URL
        let domain = "https://rayciperw.page.link"
        guard let linkBuilder = DynamicLinkComponents(link: linkParameter, domainURIPrefix: domain)
        else { return }

        // define a DynamicLinkIOSParameters object and assign it a value of app's bundleID
        if let myBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }

        // The link needs to know where to send users who don't have the app installed
        linkBuilder.iOSParameters?.appStoreID = ""

        guard let longURL = linkBuilder.url else { return }

        linkBuilder.shorten { url, warnings, error in
            if let error = error {
                return
            }

            if let warnings = warnings {
                for warning in warnings {
                    print("Warning: \(warning)")
                }
            }

            guard let url = url else { return }

            print("short url to share! \(url.absoluteString)")
        }
    }
}
