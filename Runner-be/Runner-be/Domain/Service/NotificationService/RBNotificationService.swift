//
//  NotificationService.swift
//  Runner-be
//
//  Created by 김신우 on 2022/09/02.
//

import Foundation
import RxSwift

enum RBNotification {
    case pushAlarm
}

protocol RBNotificationService {
    func sendNotification(type: RBNotification)

    var pushAlarmReceived: Observable<Void> { get }
}
