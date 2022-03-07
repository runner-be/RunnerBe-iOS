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
        let mailFrom = MailAddress(email: "runnerbe2022@gmail.com", name: "Runner-be")
        let mailTo = MailAddress(email: address, name: "Runner-be")
        let subject = "[From: Runner-be] 인증을 진행해 주세요!"
        let text = """
        안녕하세요, Runner-be 입니다!
        만약 귀하께서 요청하신 인증 메일이 아니라면 이 메일을 무시하셔도 됩니다.

        하단의 링크를 클릭해 인증을 진행해 주시면 회원님에 대한 모든 소개가 완료됩니다.

        \(dynamicLink)

        그럼, 지금부터 러너비에서 힘차게 달려볼까요!
        """

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
