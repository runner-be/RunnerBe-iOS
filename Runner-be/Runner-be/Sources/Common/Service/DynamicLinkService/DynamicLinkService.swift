//
//  DynamicLinkService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/14.
//

import Foundation
import RxSwift

protocol DynamicLinkService {
    func generateLink(resultPath: String, parameters: [String: String]) -> Observable<URL?>
}
