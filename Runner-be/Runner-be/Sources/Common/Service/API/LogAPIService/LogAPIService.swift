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
    func fetchLog(year: String, month: String) -> Observable<APIResult<LogResponse?>>
    func fetchStamp()
    func create(form: LogForm) -> Observable<APIResult<LogResult>>
    func eidt()
    func delete()
    func detail()
}
