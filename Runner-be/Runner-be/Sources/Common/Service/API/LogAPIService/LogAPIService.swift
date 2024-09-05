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

struct LogResponse {
    let runningDate: String
    let stampCode: String
}

protocol LogAPIService {
    func fetchLog(year: String, month: String) -> Observable<APIResult<(year: String, month: String)>>
    func fetchStamp()
    func create(form: LogForm) -> Observable<APIResult<LogResult>>
    func eidt()
    func delete()
    func detail()
}
