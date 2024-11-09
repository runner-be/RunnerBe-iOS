//
//  Array+.swift
//  Runner-be
//
//  Created by 김창규 on 11/9/24.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
