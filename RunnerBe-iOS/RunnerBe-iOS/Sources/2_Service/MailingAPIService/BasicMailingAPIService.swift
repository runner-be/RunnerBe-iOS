//
//  BasicMailingAPIService.swift.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/15.
//

import Foundation
import Moya
import RxSwift

final class BasicMailingAPIService: MailingAPIService {
    let provider: MoyaProvider<EmailAPI>

    init(provider: MoyaProvider<EmailAPI> = .init(plugins: [VerbosePlugin(verbose: true)])) {
        self.provider = provider
    }

    func send(mails: Mails) -> Observable<MailingAPIResult> {
        return provider.rx.request(.send(mail: mails))
            .asObservable()
            .map { $0.statusCode == 200 ? .success : .fail }
    }

    func send(mail: Mail) -> Observable<MailingAPIResult> {
        return send(mails: Mails(mails: [mail]))
    }
}
