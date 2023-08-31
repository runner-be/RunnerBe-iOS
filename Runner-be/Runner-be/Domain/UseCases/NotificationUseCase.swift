//
//  BasicRBNotificationService.swift
//  Runner-be
//
//  Created by 김신우 on 2022/09/02.
//

import Foundation
import RxSwift

enum RBNotification {
    case pushAlarm
}

final class NotificationUseCase {
    static let shared = NotificationUseCase()
    private var pushAlarm = PublishSubject<Void>()

    var pushAlarmReceived: Observable<Void> {
        pushAlarm.asObservable()
    }

    func sendNotification(type: RBNotification) {
        switch type {
        case .pushAlarm:
            pushAlarm.onNext(())
        }
    }
}
