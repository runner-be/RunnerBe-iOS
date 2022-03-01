//
//  PolicyAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//

import Foundation
import RxSwift

protocol PolicyAPIService {
    func policy(type: PolicyType) -> Observable<String>
}
