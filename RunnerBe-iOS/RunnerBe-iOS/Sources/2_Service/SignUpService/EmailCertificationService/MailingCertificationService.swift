//
//  EmailCertificationService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

enum MailingCertificationResult {
    case success
    case fail
}

protocol MailingCertificationService {
    func send(address: String, dynamicLink: String) -> Observable<MailingCertificationResult>
}
