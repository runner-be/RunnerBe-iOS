//
//  NickNameGenerator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/14.
//

import Foundation

protocol NickNameGenerator {
    func generate(numOfRandom: Int, prefix: String, suffix: String) -> String
}
