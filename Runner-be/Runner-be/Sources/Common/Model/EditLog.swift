//
//  EditLog.swift
//  Runner-be
//
//  Created by 김창규 on 9/24/24.
//

import Foundation

struct EditLog {
    let runningDate: String
    let stampCode: String
    let contents: String
    let weatherDegree: Int
    let weatherIcon: String
    let isOpened: Int
}

// {
//    "runningDate": "2024-09-05",
//    "stampCode": "RUN004",
//    "contents": "5명이서 뛰었습니다 아흉 재밌었다~",
//    "weatherDegree": 29,
//    "weatherIcon": "WEA003",
//    "isOpened": 2
// }
