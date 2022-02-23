//
//  SegmentedControlDelegate.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/24.
//

import Foundation

protocol SegmentedControlDelegate: AnyObject {
    func didChanged(_ control: SegmentedControl, from: Int, to: Int)
}
