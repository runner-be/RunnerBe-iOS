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
        if !verbose {
            return request
        }
        #if DEBUG
        #endif
        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target _: TargetType) {
        if !verbose { return }
        #if DEBUG

            switch result {
            case let .success(response):
                var requestURLString = "-"
                var requestBody = "-"
                var responseStatusCode = "-"
                var responseBody = "-"

                if let request = response.request {
                    if let url = request.url?.absoluteString {
                        requestURLString = url
                    }

                    if let body = request.httpBody {
                        if let object = try? JSONSerialization.jsonObject(with: body, options: []),
                           let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
                           let prettyPrintedString = String(data: data, encoding: .utf8)
                        {
                            requestBody = prettyPrintedString
                        } else {
                            requestBody = String(data: body, encoding: .utf8) ?? "-"
                        }
                    }
                }

                responseStatusCode = String(response.statusCode)

                if let object = try? JSONSerialization.jsonObject(with: response.data, options: []),
                   let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
                   let prettyPrintedString = String(data: data, encoding: .utf8)
                {
                    responseBody = prettyPrintedString
                } else {
                    responseBody = String(data: response.data, encoding: .utf8) ?? "-"
                }

                let message = """
                [Moya VerbosePlugin] Response
                ------------------------
                Request:
                url: \(requestURLString)
                body:
                \(requestBody)
                ------------------------
                ------------------------
                Response:
                status: \(responseStatusCode)
                body:
                \(responseBody)
                ------------------------
                """
                Log.d(tag: .network, message)

            case let .failure(err):
                let message = """
                [Moya VerbosePlugin] Response:
                Error: \(err)
                """
                Log.d(tag: .network, message)
            }

        #endif
    }
}
