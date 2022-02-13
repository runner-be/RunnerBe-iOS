//
//  SignupForm.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/13.
//

import Foundation

struct SignupForm {
    let uuid: String
    let nickName: String
    let birthday: Int
    let gender: Gender
    let job: Job
    var officeEmail: String?
    var idCardImageUrl: String?
}
