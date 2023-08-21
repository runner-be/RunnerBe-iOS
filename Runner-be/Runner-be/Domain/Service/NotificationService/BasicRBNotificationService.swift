//
//  BasicRBNotificationService.swift
//  Runner-be
//
//  Created by 김신우 on 2022/09/02.
//

import Foundation
import RxSwift

final class BasicRBNotificationService: RBNotificationService {
    static let shared = BasicRBNotificationService()

    var pushAlarmReceived: Observable<Void> {
        pushAlarm.asObservable()
    }

    func sendNotification(type: RBNotification) {
        switch type {
        case .pushAlarm:
            pushAlarm.onNext(())
        }
    }

    private var pushAlarm = PublishSubject<Void>()
}
