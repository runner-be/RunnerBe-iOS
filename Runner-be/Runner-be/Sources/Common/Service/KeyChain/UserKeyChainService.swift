//
//  UserKeyChainService.swift
//  Runner-be
//
//  Created by 김신우 on 2022/03/20.
//

import Foundation

protocol UserKeychainService {
    var uuid: String { get set }
    var deviceToken: String { get set }
    var nickName: String { get set }
    var birthDay: Int { get set }
    var job: Job { get set }
    var gender: Gender { get set }
    
    func clear()
}
