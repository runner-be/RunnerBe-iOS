//
//  2__1BookMarkComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol BookMarkDependency: Dependency {}

final class BookMarkComponent: Component<BookMarkDependency> {
    var bookMarkViewController: UIViewController {
        return shared{ BookMarkViewController() }
    }
}
