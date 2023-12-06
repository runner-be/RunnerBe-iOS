//
//  MailingAPIService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/15.
//

import Foundation
import RxSwift

enum MailingAPIResult {
    case success
    case fail
}

protocol MailingAPIService {
    func send(mails: Mails) -> Observable<MailingAPIResult>
    func send(mail: Mail) -> Observable<MailingAPIResult>
}
