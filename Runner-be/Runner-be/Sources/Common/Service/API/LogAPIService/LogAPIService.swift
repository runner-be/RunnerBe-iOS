//
//  LogAPIService.swift
//  Runner-be
//
//  Created by 김창규 on 9/4/24.
//

import Foundation
import RxSwift

enum LogResult {
    case succeed, fail, needLogin
}

protocol LogAPIService {
    func fetchLog(userId: Int, targetDate: Date) -> Observable<APIResult<LogResponse?>>
    func fetchStamp()
    func create(form: LogForm) -> Observable<APIResult<LogResult>>
    func edit(form: LogForm) -> Observable<APIResult<LogResult>>
    func delete(logId: Int) -> Observable<APIResult<LogResult>>
    func detail(logId: Int) -> Observable<APIResult<LogDetail?>>
    func partners(gatheringId: Int) -> Observable<APIResult<[LogPartners]?>>
    func postPartnerStamp(gatheringId: Int, targetId: Int, stampCode: String) -> Observable<APIResult<LogResult>>
    func editPartnerStamp(gatheringId: Int, targetId: Int, stampCode: String) -> Observable<APIResult<LogResult>>
}
