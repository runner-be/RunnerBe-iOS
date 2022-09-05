//
//  JwtToken.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/05.
//

import Foundation

struct JwtToken {
    static var token: String? = UserDefaults.standard.string(forKey: "jwt") ?? ""
}
