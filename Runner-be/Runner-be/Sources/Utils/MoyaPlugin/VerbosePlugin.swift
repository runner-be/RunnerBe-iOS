//
//  MoyaDebugPlugin.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/14.
//

import Foundation
import Moya

struct VerbosePlugin: PluginType {
    let verbose: Bool

    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        #if DEBUG
            if let body = request.httpBody,
               let str = String(data: body, encoding: .utf8)
            {
                if verbose {
                    print("[MOYA VerbosePlugin] request to send: \(str)")
                }
            }
        #endif
        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target _: TargetType) {
        #if DEBUG
            switch result {
            case let .success(body):
                if verbose {
                    print("[MOYA VerbosePlugin] Response:")
                    if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
                        print(json)
                    } else {
                        let response = String(data: body.data, encoding: .utf8)!.removingPercentEncoding!
                        print(response)
                    }
                }
            case .failure:
                break
            }
        #endif
    }
}
