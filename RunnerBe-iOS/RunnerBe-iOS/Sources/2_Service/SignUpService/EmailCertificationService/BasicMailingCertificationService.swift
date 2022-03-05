//
//  BasicEmailCertificationService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation
import RxSwift

final class BasicMailingCertificationService: MailingCertificationService {
    let mailingAPIService: MailingAPIService

    init(mailingAPIService: MailingAPIService) {
        self.mailingAPIService = mailingAPIService
    }

    func send(address: String, dynamicLink: String) -> Observable<MailingCertificationResult> {
        let mailFrom = MailAddress(email: "sinsdhk@gmail.com", name: "RunnerBe")
        let mailTo = MailAddress(email: address, name: "Runner")
        let subject = "[From: RunnerBe] 인증을 진행해 주세요!"
        let text = "안녕하세요 러너비입니다.\n\n아래 링크를 통해 회원가입 절차를 완료해 주세요!\n\n\(dynamicLink) "

        let mail = Mail(from: mailFrom, to: [mailTo], subject: subject, textPart: text, htmlPart: nil)

        return mailingAPIService.send(mail: mail)
            .map {
                switch $0 {
                case .success:
                    return .success
                case .fail:
                    return .fail
                }
            }
    }
}
