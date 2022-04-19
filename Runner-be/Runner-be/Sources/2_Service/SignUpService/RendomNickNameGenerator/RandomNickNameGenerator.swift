//
//  RandomNickNameGenerator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/14.
//

import Foundation

final class RandomNickNameGenerator {
    static func generate(numOfRandom: Int, prefix: String, suffix: String) -> String {
        let words = "0123456789"

        let numOfRandom = numOfRandom < 0 ? 0 : numOfRandom

        let randomResult = (0 ..< numOfRandom).reduce("") { partialResult, _ in
            let randomIdx = Int.random(in: 0 ..< words.count)
            return partialResult + words[randomIdx]
        }

        return prefix + randomResult + suffix
    }
}
